import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    
    
    
    
    var l = 0
    var healthLost = 0
    var heart1 = SKSpriteNode(imageNamed: "heart")
    var heart2 = SKSpriteNode(imageNamed: "heart")
    var heart3 = SKSpriteNode(imageNamed: "heart")
    var selectedNodes:[UITouch:SKSpriteNode] = [UITouch:SKSpriteNode]()
    var bossHealthBar = SKSpriteNode(imageNamed: "healthBar400")
    var sprite = SKSpriteNode(imageNamed: "stand1")
    var treenemy = SKSpriteNode(imageNamed: "tree00")
    var purpleGuy = SKSpriteNode(imageNamed: "purpleGuy00")
    var retroGuy = SKSpriteNode(imageNamed: "retroGuy00")
    var stouter = SKSpriteNode(imageNamed: "stouter00")
    var kanji = SKSpriteNode(imageNamed: "Kanji00")
    var shangTsung = SKSpriteNode(imageNamed: "bossStanding00")
    var frie = SKSpriteNode(imageNamed: "frie00")
    var world: SKNode
    var gameOver = SKSpriteNode(imageNamed: "Pce_gameover")
    var attackButton = SKSpriteNode(imageNamed: "Xbox360_Button_A")
    var levelBeat = SKAction.playSoundFileNamed("remixHam.wav", waitForCompletion: true)
    var gameFinish = SKAction.playSoundFileNamed("gameComplete.wav", waitForCompletion: true)
    var soundRun = SKAction.playSoundFileNamed("running.wav", waitForCompletion: true)
    var soundAttack = SKAction.playSoundFileNamed("swoosh.wav", waitForCompletion: true)
    var soundHurt = SKAction.playSoundFileNamed("striderHurt.wav", waitForCompletion: true)
    var soundJump = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: true)
    var soundKanji = SKAction.playSoundFileNamed("kanjiDeath.wav", waitForCompletion: true)
    var soundRetro = SKAction.playSoundFileNamed("8bitHurt.aiff", waitForCompletion: true)
    var soundTree = SKAction.playSoundFileNamed("treePain.wav", waitForCompletion: true)
    var soundStout = SKAction.playSoundFileNamed("stouterPain.wav", waitForCompletion: true)
    var soundPurple = SKAction.playSoundFileNamed("purplePain.wav", waitForCompletion: true)
    var heartsLeft = 3
    var levelOneBeat = false
    var bossFight = false
    var gameWin = false
    var containerNode = SKNode()
    
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    
    override func didMoveToView(view: SKView) {
        self.addChild(attackButton)
        self.addChild(gameOver)
        
        
        resetGame()
        
    }
    
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        backgroundMusicPlayer =
            AVAudioPlayer(contentsOfURL: url, error: &error)
        if backgroundMusicPlayer == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    
    func playSound(sound: SKAction) {
        runAction(sound)
    }
    
    func resetGame() {
        world = self.childNodeWithName("world")!
        playBackgroundMusic("cutmusicbox.mp3")
        
        
        shangTsung.position = CGPointMake(4200, -490)
        frie.position = CGPointMake(4000, 500)
        treenemy.position = CGPointMake(800, -375)
        purpleGuy.position = CGPointMake(493, -460)
        kanji.position = CGPointMake(1500, -412)
        stouter.position = CGPointMake(600, -398)
        sprite.position = CGPointMake(112, -450)
        retroGuy.position = CGPointMake(1200, -390)
        heart1.position = CGPointMake(50, 700)
        heart2.position = CGPointMake(150, 700)
        heart3.position = CGPointMake(250, 700)
        bossHealthBar.position = CGPointMake(4500, 0)
        heartsLeft = 3
        
        switchToStandingAnimation()
        
        self.addChild(heart1)
        self.addChild(heart2)
        self.addChild(heart3)
        world.addChild(sprite)
        world.addChild(treenemy)
        world.addChild(purpleGuy)
        world.addChild(stouter)
        world.addChild(retroGuy)
        world.addChild(kanji)
        world.addChild(containerNode)
        world.addChild(bossHealthBar)
        containerNode.addChild(shangTsung)
        containerNode.addChild(frie)
        
        
        attackButton.position = CGPointMake(512, 40)
        sprite.zPosition = 400
        stouter.zPosition = 150
        retroGuy.zPosition = 100
        treenemy.zPosition = 50
        purpleGuy.zPosition = 500
        shangTsung.zPosition = 401
        attackButton.zPosition = 750
        heart1.zPosition = 1000
        heart2.zPosition = 1000
        heart3.zPosition = 1000
        kanji.zPosition = 300
        retroGuy.xScale = 0.3
        retroGuy.yScale = 0.3
        kanji.xScale = 0.5
        kanji.yScale = 0.5
        bossHealthBar.xScale = 7
        bossHealthBar.yScale = 7
        purpleGuy.xScale = 0.6
        purpleGuy.yScale = 0.6
        shangTsung.xScale = 1.5
        shangTsung.yScale = 1.5
        heart1.alpha = 1
        heart2.alpha = 1
        heart3.alpha = 1
        
        self.gameOver.zPosition = 10000
        self.gameOver.position = CGPointMake(512, 384)
        self.gameOver.alpha = 0
        self.gameOver.size = self.size
        
        let treeWalkLeft = SKAction.moveBy(CGVectorMake(-200, 0), duration: 1)
        let treeWalkRight = treeWalkLeft.reversedAction()
        let stouterWalking = loadAnimation("stouter")
        let stouterWalkLeft = SKAction.moveBy(CGVectorMake(-500, 0), duration: 1.8)
        let stouterWalkRight = stouterWalkLeft.reversedAction()
        let purpleWalking = loadAnimation("purpleGuy", timePerFrame: 0.4)
        let purpleWalkLeft = SKAction.moveBy(CGVectorMake(-150, 0), duration: 1.2)
        let purpleWalkRight = purpleWalkLeft.reversedAction()
        let retroWalking = loadAnimation("retroGuy")
        let retroWalkLeft = SKAction.moveBy(CGVectorMake(-800, 0), duration: 5)
        let retroWalkRight = retroWalkLeft.reversedAction()
        let kanjiWalking = loadAnimation("Kanji", timePerFrame: 0.1)
        let kanjiWalkLeft = SKAction.moveBy(CGVectorMake(-1000, 0), duration: 9)
        let kanjiWalkRight = kanjiWalkLeft.reversedAction()
        let tsungWalkLeft = SKAction.moveBy(CGVectorMake(-500, 0), duration: 2.16)
        let tsungWalkRight = tsungWalkLeft.reversedAction()
        let tsungWalking = loadAnimation("bossWalks", timePerFrame: 0.08)
        let tsungFiring = loadAnimation("bossShoot", timePerFrame: 0.08)
        let frieFlyLeft = SKAction.moveBy(CGVectorMake(-1500, 0), duration: 2.72)
        let frieFlyRight = frieFlyLeft.reversedAction()
        let frieFlying = loadAnimation("frie", timePerFrame: 0.08)
        
        //CGPOINT   shangTsung.position.x+50, etc...
        let frieGetShot = SKAction.moveTo(CGPointMake(shangTsung.position.x, -435), duration: 0)
        
        
        let treeFaceLeft = SKAction.scaleXTo(-1, duration: 0)
        let treeFaceRight = SKAction.scaleXTo(1, duration: 0)
        let stouterFaceLeft = SKAction.scaleXTo(-1, duration: 0)
        let stouterFaceRight = SKAction.scaleXTo(1, duration: 0)
        let purpleFaceLeft = SKAction.scaleXTo(0.6, duration: 0)
        let purpleFaceRight = SKAction.scaleXTo(-0.6, duration: 0)
        let retroFaceLeft = SKAction.scaleXTo(0.3, duration: 0)
        let retroFaceRight = SKAction.scaleXTo(-0.3, duration: 0)
        let kanjiFaceLeft = SKAction.scaleXTo(0.5, duration: 0)
        let kanjiFaceRight = SKAction.scaleXTo(-0.5, duration: 0)
        let tsungFaceLeft = SKAction.scaleXTo(-1, duration: 0)
        let tsungFaceRight = SKAction.scaleXTo(1, duration: 0)
        let frieTurnLeft = SKAction.scaleXTo(-1, duration: 0)
        let frieTurnRight = SKAction.scaleXTo(1, duration: 0)
        
        treenemy.runAction(SKAction.repeatActionForever(SKAction.sequence([treeWalkRight, treeFaceLeft, treeWalkLeft, treeFaceRight])), withKey: "tree patrol")
        treenemy.runAction(SKAction.repeatActionForever(loadAnimation("tree")), withKey: "tree walk")
        stouter.runAction(SKAction.repeatActionForever(SKAction.sequence([stouterWalkRight, stouterFaceLeft, stouterWalkLeft, stouterFaceRight])), withKey: "stouter patrol")
        stouter.runAction(SKAction.repeatActionForever(stouterWalking), withKey: "stouter walk")
        purpleGuy.runAction(SKAction.repeatActionForever(SKAction.sequence([purpleWalkLeft, purpleFaceRight, purpleWalkRight, purpleFaceLeft])), withKey: "purple patrol")
        purpleGuy.runAction(SKAction.repeatActionForever(purpleWalking), withKey: "purple walk")
        retroGuy.runAction(SKAction.repeatActionForever(SKAction.sequence([retroWalkLeft, retroFaceRight, retroWalkRight, retroFaceLeft])), withKey: "retro patrol")
        retroGuy.runAction(SKAction.repeatActionForever(retroWalking), withKey: "retro walk")
        kanji.runAction(SKAction.repeatActionForever(SKAction.sequence([kanjiWalkLeft, kanjiFaceRight, kanjiWalkRight, kanjiFaceLeft])), withKey: "kanji patrol")
        kanji.runAction(SKAction.repeatActionForever(kanjiWalking), withKey: "kanji walk")
//        shangTsung.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.group([tsungWalkRight, SKAction.repeatAction(tsungWalking, count: 3)]), tsungFaceLeft, tsungFiring, SKAction.runBlock({
//            self.frie.runAction(SKAction.moveTo(CGPointMake(self.shangTsung.position.x, self.shangTsung.position.y + 45), duration: 0))
//            self.frie.runAction(frieTurnLeft)
//            self.frie.runAction(frieFlyLeft)
//        }), SKAction.group([tsungWalkLeft, SKAction.repeatAction(tsungWalking, count: 3)]), tsungFaceRight, tsungFiring, SKAction.runBlock({
//            self.frie.runAction(SKAction.moveTo(CGPointMake(self.shangTsung.position.x, self.shangTsung.position.y + 45), duration: 0))
//            self.frie.runAction(frieTurnRight)
//            self.frie.runAction(frieFlyRight)
//        })])), withKey: "tsung patrol")
        frie.runAction(SKAction.repeatActionForever(frieFlying), withKey: "fireAnim")
        
        
        
        
        
    }
    
    func loadAnimation(name : String, timePerFrame : Double = 0.05) -> SKAction {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2
        
        let atlas = SKTextureAtlas(named: name)
        var frames = NSMutableArray()
        
        for i in 0..<atlas.textureNames.count {
            let num = formatter.stringFromNumber(i)
            let filename = name + num!
            frames.addObject(atlas.textureNamed(filename))
        }
        return SKAction.animateWithTextures(frames as [AnyObject], timePerFrame: timePerFrame, resize: true, restore: false)
    }
    
    func sceneAButtonPressed() {
        if (sprite.actionForKey("jumping up") == nil) {
            
            let attackAtlas = SKTextureAtlas(named: "attack")
            var attack = NSMutableArray()
            
            playSound(soundAttack)
            
            for i in 1..<16 {
                attack.addObject(attackAtlas.textureNamed("attack\(i)"))
            }
            
            let attacking = SKAction.animateWithTextures(attack as [AnyObject], timePerFrame: 0.05, resize: true, restore: true)
            sprite.removeActionForKey("run")
            sprite.removeActionForKey("strider")
            sprite.runAction(attacking, withKey: "attacking")
            
            let spritex = sprite.position.x + 102
            
            
            let treeDeathAtlas = SKTextureAtlas(named: "death")
            var treeDeath = NSMutableArray()
            
            for i in 0..<10 {
                treeDeath.addObject(treeDeathAtlas.textureNamed("death0\(i)"))
            }
            
            for i in 10..<24 {
                treeDeath.addObject(treeDeathAtlas.textureNamed("death\(i)"))
            }
            
            let stouterDeathAtlas = SKTextureAtlas(named: "stouterdeath")
            var stouterDeath = NSMutableArray()
            
            for i in 0..<10 {
                stouterDeath.addObject(stouterDeathAtlas.textureNamed("stouterDeath0\(i)"))
            }
            
            let purpleDeathAtlas = SKTextureAtlas(named: "purpleDeath")
            var purpleDeath = NSMutableArray()
            
            for i in 0..<10 {
                purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath0\(i)"))
            }
            
            for i in 10..<15 {
                purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath\(i)"))
            }
            
            
            let retroDeathAtlas = SKTextureAtlas(named: "retrodeath")
            var retroDeath = NSMutableArray()
            
            for i in 1..<18 {
                retroDeath.addObject(retroDeathAtlas.textureNamed("retroDeath\(i)"))
            }
            
            let kanjiDeathAtlas = SKTextureAtlas(named: "kanjideath")
            var kanjiDeath = NSMutableArray()
            
            for i in 0..<10 {
                kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath0\(i)"))
            }
            
            for i in 10..<25 {
                kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath\(i)"))
            }
            
            
            
            let treeDeathAnim = SKAction.animateWithTextures(treeDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let stouterDeathAnim = SKAction.animateWithTextures(stouterDeath as [AnyObject], timePerFrame: 0.05, resize: true, restore: false)
            let purpleDeathAnim = SKAction.animateWithTextures(purpleDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let retroDeathAnim = SKAction.animateWithTextures(retroDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let kanjiDeathAnim = SKAction.animateWithTextures(kanjiDeath as [AnyObject], timePerFrame: 0.03, resize: false, restore: false)
            
            if ((treenemy.containsPoint(CGPointMake(spritex, -375))) && (sprite.xScale > 0)) || ((treenemy.containsPoint(CGPointMake(spritex - 205, -375)) && (sprite.xScale < 0))) {
                treenemy.removeActionForKey("tree walk")
                treenemy.removeActionForKey("tree patrol")
                playSound(soundTree)
                treenemy.runAction(SKAction.sequence([treeDeathAnim, SKAction.removeFromParent()]))
            }
            
            if ((stouter.containsPoint(CGPointMake(spritex, -398))) && (sprite.xScale > 0)) || ((stouter.containsPoint(CGPointMake(spritex - 205, -398)) && (sprite.xScale < 0))) {
                stouter.removeActionForKey("stouter walk")
                stouter.removeActionForKey("stouter patrol")
                playSound(soundStout)
                stouter.runAction(SKAction.sequence([stouterDeathAnim, SKAction.removeFromParent()]))
            }
            
            
            if ((purpleGuy.containsPoint(CGPointMake(spritex, -460))) && (sprite.xScale > 0) || (purpleGuy.containsPoint(CGPointMake(spritex - 205, -460)) && (sprite.xScale < 0))) {
                purpleGuy.removeActionForKey("purple walk")
                purpleGuy.removeActionForKey("purple patrol")
                playSound(soundPurple)
                purpleGuy.runAction(SKAction.sequence([purpleDeathAnim, SKAction.removeFromParent()]))
            }
            
            
            if ((retroGuy.containsPoint(CGPointMake(spritex, -390))) && (sprite.xScale > 0)) || ((retroGuy.containsPoint(CGPointMake(spritex - 205, -390)) && (sprite.xScale < 0))) {
                retroGuy.removeActionForKey("retro walk")
                retroGuy.removeActionForKey("retro patrol")
                playSound(soundRetro)
                retroGuy.runAction(SKAction.sequence([retroDeathAnim, SKAction.removeFromParent()]))
            }
            
            
            if ((kanji.containsPoint(CGPointMake(spritex, -412))) && (sprite.xScale > 0)) || ((kanji.containsPoint(CGPointMake(spritex - 205, -412)) && (sprite.xScale < 0))) {
                kanji.removeActionForKey("kanji walk")
                kanji.removeActionForKey("kanji patrol")
                playSound(soundKanji)
                kanji.runAction(SKAction.sequence([kanjiDeathAnim, SKAction.removeFromParent()]))
            }
            
            if ((shangTsung.containsPoint(CGPointMake(spritex, -490))) && (sprite.xScale > 0)) || ((shangTsung.containsPoint(CGPointMake(spritex - 205, -490))) && (sprite.xScale < 0)) {
                healthLost++
                
            }
            
        } else if (sprite.actionForKey("jumping up") != nil) {
            let airAttackAtlas = SKTextureAtlas(named: "airattack")
            var airAttack = NSMutableArray()
            
            for i in 0..<4 {
                airAttack.addObject(airAttackAtlas.textureNamed("airattack0\(i)"))
            }
            
            let spritex = sprite.position.x + 46
            
            let spriteLanding = -(sprite.position.y + 400)
            
            let spritey = sprite.position.y - 59
            
            let airAttacking = SKAction.animateWithTextures(airAttack as [AnyObject], timePerFrame: 0.08, resize: true, restore: true)
            let airAttacks = SKAction.moveToY(-450, duration: 0.32)
            
            
            
            let treeDeathAtlas = SKTextureAtlas(named: "death")
            var treeDeath = NSMutableArray()
            
            for i in 0..<10 {
                treeDeath.addObject(treeDeathAtlas.textureNamed("death0\(i)"))
            }
            
            for i in 10..<24 {
                treeDeath.addObject(treeDeathAtlas.textureNamed("death\(i)"))
            }
            
            
            let stouterDeathAtlas = SKTextureAtlas(named: "stouterdeath")
            var stouterDeath = NSMutableArray()
            
            for i in 0..<10 {
                stouterDeath.addObject(stouterDeathAtlas.textureNamed("stouterDeath0\(i)"))
            }
            
            let purpleDeathAtlas = SKTextureAtlas(named: "purpleDeath")
            var purpleDeath = NSMutableArray()
            
            for i in 0..<10 {
                purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath0\(i)"))
            }
            
            for i in 10..<15 {
                purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath\(i)"))
            }
            
            
            let retroDeathAtlas = SKTextureAtlas(named: "retrodeath")
            var retroDeath = NSMutableArray()
            
            for i in 1..<18 {
                retroDeath.addObject(retroDeathAtlas.textureNamed("retroDeath\(i)"))
            }
            
            let kanjiDeathAtlas = SKTextureAtlas(named: "kanjideath")
            var kanjiDeath = NSMutableArray()
            
            for i in 0..<10 {
                kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath0\(i)"))
            }
            
            for i in 10..<25 {
                kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath\(i)"))
            }
            
            let treeDeathAnim = SKAction.animateWithTextures(treeDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let stouterDeathAnim = SKAction.animateWithTextures(stouterDeath as [AnyObject], timePerFrame: 0.05, resize: true, restore: false)
            let purpleDeathAnim = SKAction.animateWithTextures(purpleDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let retroDeathAnim = SKAction.animateWithTextures(retroDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
            let kanjiDeathAnim = SKAction.animateWithTextures(kanjiDeath as [AnyObject], timePerFrame: 0.03, resize: false, restore: false)
            
            sprite.removeActionForKey("jumping up")
            
            sprite.runAction(SKAction.group([airAttacking, airAttacks]), withKey: "airattacking")
            
            if ((treenemy.containsPoint(CGPointMake(spritex, spritey))) && (sprite.xScale > 0)) || ((treenemy.containsPoint(CGPointMake(spritex - 93, spritey))) && (sprite.xScale < 0)) {
                treenemy.removeActionForKey("tree walk")
                treenemy.removeActionForKey("tree patrol")
                playSound(soundTree)
                treenemy.runAction(SKAction.sequence([treeDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if ((stouter.containsPoint(CGPointMake(spritex, spritey))) && (sprite.xScale > 0)) || ((stouter.containsPoint(CGPointMake(spritex - 93, spritey))) && (sprite.xScale < 0)) {
                stouter.removeActionForKey("stouter walk")
                stouter.removeActionForKey("stouter patrol")
                playSound(soundStout)
                stouter.runAction(SKAction.sequence([stouterDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if ((purpleGuy.containsPoint(CGPointMake(spritex, spritey))) && (sprite.xScale > 0)) || ((purpleGuy.containsPoint(CGPointMake(spritex - 93, spritey))) && (sprite.xScale < 0)) {
                purpleGuy.removeActionForKey("purple walk")
                purpleGuy.removeActionForKey("purple patrol")
                playSound(soundPurple)
                purpleGuy.runAction(SKAction.sequence([purpleDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if (((retroGuy.containsPoint(CGPointMake(spritex, spritey))) && (sprite.xScale > 0)) || ((retroGuy.containsPoint(CGPointMake(spritex - 93, spritey))) && (sprite.xScale < 0))) && retroGuy.parent != nil {
                retroGuy.removeActionForKey("retro walk")
                retroGuy.removeActionForKey("retro patrol")
                playSound(soundRetro)
                retroGuy.runAction(SKAction.sequence([retroDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if (((kanji.containsPoint(CGPointMake(spritex, spritey))) && (sprite.xScale > 0)) || ((kanji.containsPoint(CGPointMake(spritex - 93, spritey))) && (sprite.xScale < 0))) && kanji.parent != nil {
                kanji.removeActionForKey("kanji walk")
                kanji.removeActionForKey("kanji patrol")
                playSound(soundKanji)
                kanji.runAction(SKAction.sequence([kanjiDeathAnim, SKAction.removeFromParent(), SKAction.waitForDuration(1)]), withKey: "Death")
            }
            
            
        }
    }
    
    
    
    
    func switchToStandingAnimation() {
        if sprite.actionForKey("dying") == nil {
            let atlas2 = SKTextureAtlas(named: "standing")
            var textures2 = NSMutableArray()
            
            for i in 1..<19 {
                textures2.addObject(atlas2.textureNamed("stand\(i)"))
            }
            
            
            let action2 = SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.05, resize: true, restore: true)
            
            sprite.runAction(SKAction.repeatActionForever(action2), withKey: "standing")
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for t: UITouch in touches as! Set<UITouch> {
            if gameOver.alpha == 0 {
                if sprite.actionForKey("dying") == nil {
                    let coords = t.locationInView(t.view)
                    let w = view?.frame.width
                    let h = view?.frame.height
                    let locInButton = t.locationInNode(attackButton as SKNode)
                    if sprite.actionForKey("striderS") == nil {
                        if locInButton.x < 20 && locInButton.x > -20 && locInButton.y < 20 && locInButton.y > -20 {
                            sceneAButtonPressed()
                        } else if coords.x < w!/2 && coords.y > h!/2 {
                            startRunning(false)
                        } else if coords.x >= w!/2 && coords.y > h!/2 {
                            startRunning(true)
                        } else if coords.y < h!/2 {
                            if (sprite.actionForKey("airattacking") == nil) {
                                let jump = SKAction.moveBy(CGVectorMake(0, 200), duration: 0.5)
                                
                                let fall = SKAction.moveBy(CGVectorMake(0, -200), duration: 1)
                                playSound(soundJump)
                                let atlas3 = SKTextureAtlas(named: "jumping")
                                var jumpTextures = NSMutableArray()
                                
                                let atlas4 = SKTextureAtlas(named: "fall")
                                var textures4 = NSMutableArray()
                                
                                for i in 1..<3 {
                                    jumpTextures.addObject(atlas3.textureNamed("jump\(i)"))
                                }
                                
                                
                                for i in 1..<3 {
                                    textures4.addObject(atlas4.textureNamed("fall\(i)"))
                                }
                                
                                let atlas5 = SKTextureAtlas(named: "crouch")
                                var texture5 = NSMutableArray()
                                
                                for i in 1..<6 {
                                    texture5.addObject(atlas5.textureNamed("crouch\(i)"))
                                }
                                
                                
                                if (sprite.actionForKey("jumping up") == nil) {
                                    let jumpAnim = SKAction.repeatAction(SKAction.animateWithTextures(jumpTextures as [AnyObject], timePerFrame: 0.05, resize: true, restore: true), count: 5)
                                    
                                    let fallAnim = SKAction.repeatAction(SKAction.animateWithTextures(textures4 as [AnyObject], timePerFrame: 0.05, resize: true, restore: true), count: 10)
                                    
                                    let landAnim = SKAction.animateWithTextures(texture5 as [AnyObject], timePerFrame: 0.05, resize: true, restore: true)
                                    
                                    sprite.runAction(SKAction.sequence([SKAction.group([jump, jumpAnim]), SKAction.group([fall, fallAnim]), landAnim]), withKey: "jumping up")
                                    
                                    //      sprite.removeActionForKey("run")
                                }
                                
                            }
                        }
                    }
                }
            } else {
                self.removeAllActions()
                sprite.removeFromParent()
                treenemy.removeFromParent()
                kanji.removeFromParent()
                stouter.removeFromParent()
                purpleGuy.removeFromParent()
                retroGuy.removeFromParent()
                heart1.removeFromParent()
                heart2.removeFromParent()
                heart3.removeFromParent()
                shangTsung.removeFromParent()
                frie.removeFromParent()
                containerNode.removeFromParent()
                backgroundMusicPlayer.stop()
                bossHealthBar.removeFromParent()
                levelOneBeat = false
                bossFight = false
                healthLost = 0
                resetGame()
                
            }
        }
    }
    
    func startRunning(right : Bool) {
        let atlas = SKTextureAtlas(named: "strider")
        var textures = NSMutableArray()
        
        self.runAction(SKAction.repeatActionForever(soundRun), withKey: "soundrun")
        
        for i in 1..<6 {
            textures.addObject(atlas.textureNamed("run\(i)"))
        }
        
        var speed = right ? 250.0 : -250.0
        
        
        let action = SKAction.moveBy(CGVectorMake(CGFloat(speed), 0), duration: 1)
        
        sprite.runAction(SKAction.repeatActionForever(action), withKey: "run")
        
        if (right && sprite.xScale < 0) || (!right && sprite.xScale > 0) {
            sprite.xScale = -sprite.xScale;
        }
        
        let action3 = SKAction.animateWithTextures(textures as [AnyObject], timePerFrame: 0.05, resize: true, restore: true)
        
        sprite.runAction(SKAction.repeatActionForever(action3), withKey: "strider")
        
    }
    
    
    func cutSceneRun() {
        let atlas = SKTextureAtlas(named: "strider")
        var textures = NSMutableArray()
        
        for i in 1..<6 {
            textures.addObject(atlas.textureNamed("run\(i)"))
        }
        
        self.removeActionForKey("soundrun")
        
        let shrinkDown = SKAction.scaleBy(0.3, duration: 9)
        let growUp = SKAction.scaleBy(1/0.3, duration: 0)
        let moveToCave = SKAction.moveTo(CGPointMake(2050, -425), duration: 9)
        let moveToLevelTwo = SKAction.moveTo(CGPointMake(3300, -450), duration: 0)
        
        
        let action3 = SKAction.animateWithTextures(textures as [AnyObject], timePerFrame: 0.05, resize: true, restore: true)
        
        let atlas2 = SKTextureAtlas(named: "standing")
        var textures2 = NSMutableArray()
        
        for i in 1..<19 {
            textures2.addObject(atlas2.textureNamed("stand\(i)"))
        }
        
        
        let action2 = SKAction.repeatActionForever(SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.05, resize: true, restore: true))
        
        sprite.runAction(SKAction.repeatAction(action3, count: 36), withKey: "striderS")
        
        sprite.runAction(SKAction.sequence([SKAction.group([levelBeat, shrinkDown, moveToCave]), moveToLevelTwo, growUp, SKAction.runBlock({ self.playBackgroundMusic("Level2.wav")}), action2]))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if sprite.actionForKey("striderS") == nil {
                if (sprite.actionForKey("jumping up") == nil) && sprite.actionForKey("attacking") == nil && sprite.actionForKey("airattacking") == nil {
                    switchToStandingAnimation()
                }
                sprite.removeActionForKey("run")
                sprite.removeActionForKey("strider")
                self.removeActionForKey("soundrun")
            }
        }
    }
    
    override func didFinishUpdate() {
        if ((sprite.position.x > 97 && sprite.position.x < 1500) || (sprite.position.x > 3000 && sprite.position.x < 5000)) && !bossFight {
            world.position = CGPointMake(-sprite.position.x + 312, -sprite.position.y + 210)
        }
        if sprite.position.x < -140 {
            sprite.runAction(SKAction.moveTo(CGPointMake(-140, sprite.position.y), duration: 0))
        }
        
        if sprite.position.x > 2200 &&  sprite.position.x < 2500 {
            sprite.runAction(SKAction.moveTo(CGPointMake(2200, sprite.position.y), duration: 0))
        }
        
        if sprite.position.x > 2600 && sprite.position.x < 2750 {
            sprite.runAction(SKAction.moveTo(CGPointMake(2750, sprite.position.y), duration: 0))
        }
        
        if sprite.position.x < 3750 && bossFight {
            sprite.runAction(SKAction.moveTo(CGPointMake(3750, sprite.position.y), duration: 0))
        }
        
        let enemies = [kanji, treenemy, stouter, purpleGuy, retroGuy, frie, shangTsung]
        
        var e = 0
        
        for i in enemies {
            if i.parent == nil {
                e++
            }
        }
        
        if (sprite.position.x >= 1800) && (e == 5) && !levelOneBeat {
            levelOneBeat = true
            sprite.removeAllActions()
            backgroundMusicPlayer.stop()
            cutSceneRun()
            
            
        }
        
        
        
        if bossFight && l == 0 {
            l++
            
            
            let tsungFaceLeft = SKAction.scaleXTo(-1, duration: 0)
            let tsungFaceRight = SKAction.scaleXTo(1, duration: 0)
            let frieTurnLeft = SKAction.scaleXTo(-1, duration: 0)
            let frieTurnRight = SKAction.scaleXTo(1, duration: 0)
            
            let tsungWalkLeft = SKAction.moveBy(CGVectorMake(-500, 0), duration: 2.16)
            let tsungWalkRight = tsungWalkLeft.reversedAction()
            let tsungWalking = loadAnimation("bossWalks", timePerFrame: 0.08)
            let tsungFiring = loadAnimation("bossShoot", timePerFrame: 0.08)
            let frieFlyLeft = SKAction.moveBy(CGVectorMake(-1500, 0), duration: 2.72)
            let frieFlyRight = frieFlyLeft.reversedAction()
            let frieFlying = loadAnimation("frie", timePerFrame: 0.08)
            
            //CGPOINT   shangTsung.position.x+50, etc...
            let frieGetShot = SKAction.moveTo(CGPointMake(shangTsung.position.x, -435), duration: 0)
            
            shangTsung.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.group([tsungWalkRight, SKAction.repeatAction(tsungWalking, count: 3)]), tsungFaceLeft, tsungFiring, SKAction.runBlock({
                self.frie.runAction(SKAction.moveTo(CGPointMake(self.shangTsung.position.x, self.shangTsung.position.y + 45), duration: 0))
                self.frie.runAction(frieTurnLeft)
                self.frie.runAction(frieFlyLeft)
            }), SKAction.group([tsungWalkLeft, SKAction.repeatAction(tsungWalking, count: 3)]), tsungFaceRight, tsungFiring, SKAction.runBlock({
                self.frie.runAction(SKAction.moveTo(CGPointMake(self.shangTsung.position.x, self.shangTsung.position.y + 45), duration: 0))
                self.frie.runAction(frieTurnRight)
                self.frie.runAction(frieFlyRight)
            })])), withKey: "tsung patrol")
        }
        
        
        
        
        let treeDeathAtlas = SKTextureAtlas(named: "death")
        var treeDeath = NSMutableArray()
        
        for i in 0..<10 {
            treeDeath.addObject(treeDeathAtlas.textureNamed("death0\(i)"))
        }
        
        for i in 10..<24 {
            treeDeath.addObject(treeDeathAtlas.textureNamed("death\(i)"))
        }
        
        
        let stouterDeathAtlas = SKTextureAtlas(named: "stouterdeath")
        var stouterDeath = NSMutableArray()
        
        for i in 0..<10 {
            stouterDeath.addObject(stouterDeathAtlas.textureNamed("stouterDeath0\(i)"))
        }
        
        let purpleDeathAtlas = SKTextureAtlas(named: "purpleDeath")
        var purpleDeath = NSMutableArray()
        
        for i in 0..<10 {
            purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath0\(i)"))
        }
        
        for i in 10..<15 {
            purpleDeath.addObject(purpleDeathAtlas.textureNamed("purpleDeath\(i)"))
        }
        
        
        let retroDeathAtlas = SKTextureAtlas(named: "retrodeath")
        var retroDeath = NSMutableArray()
        
        for i in 1..<18 {
            retroDeath.addObject(retroDeathAtlas.textureNamed("retroDeath\(i)"))
        }
        
        let kanjiDeathAtlas = SKTextureAtlas(named: "kanjideath")
        var kanjiDeath = NSMutableArray()
        
        for i in 0..<10 {
            kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath0\(i)"))
        }
        
        for i in 10..<25 {
            kanjiDeath.addObject(kanjiDeathAtlas.textureNamed("kanjiDeath\(i)"))
        }
        
        let treeDeathAnim = SKAction.animateWithTextures(treeDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
        let stouterDeathAnim = SKAction.animateWithTextures(stouterDeath as [AnyObject], timePerFrame: 0.05, resize: true, restore: false)
        let purpleDeathAnim = SKAction.animateWithTextures(purpleDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
        let retroDeathAnim = SKAction.animateWithTextures(retroDeath as [AnyObject], timePerFrame: 0.03, resize: true, restore: false)
        let kanjiDeathAnim = SKAction.animateWithTextures(kanjiDeath as [AnyObject], timePerFrame: 0.03, resize: false, restore: false)
        
        if sprite.actionForKey("airattacking") != nil {
            if treenemy.frame.intersects(sprite.frame) && treenemy.parent != nil {
                treenemy.removeActionForKey("tree walk")
                treenemy.removeActionForKey("tree patrol")
                playSound(soundTree)
                treenemy.runAction(SKAction.sequence([treeDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if stouter.frame.intersects(sprite.frame) && stouter.parent != nil {
                stouter.removeActionForKey("stouter walk")
                stouter.removeActionForKey("stouter patrol")
                playSound(soundStout)
                stouter.runAction(SKAction.sequence([stouterDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if purpleGuy.frame.intersects(sprite.frame) && purpleGuy.parent != nil {
                purpleGuy.removeActionForKey("purple walk")
                purpleGuy.removeActionForKey("purple patrol")
                playSound(soundPurple)
                purpleGuy.runAction(SKAction.sequence([purpleDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if retroGuy.frame.intersects(sprite.frame) && retroGuy.parent != nil {
                retroGuy.removeActionForKey("retro walk")
                retroGuy.removeActionForKey("retro patrol")
                playSound(soundRetro)
                retroGuy.runAction(SKAction.sequence([retroDeathAnim, SKAction.removeFromParent()]), withKey: "Death")
            }
            
            if kanji.frame.intersects(sprite.frame) && kanji.parent != nil {
                kanji.removeActionForKey("kanji walk")
                kanji.removeActionForKey("kanji patrol")
                playSound(soundKanji)
                kanji.runAction(SKAction.sequence([kanjiDeathAnim, SKAction.removeFromParent(), SKAction.waitForDuration(1)]), withKey: "Death")
            }
            
            if shangTsung.frame.intersects(sprite.frame) && shangTsung.parent != nil {
                healthLost++
            }
        }
        
        if healthLost == 0 {
            bossHealthBar.texture = SKTexture(imageNamed: "healthBar400")
        }
        
        if healthLost == 1 {
            bossHealthBar.texture = SKTexture(imageNamed: "healthBar401")
        }
        
        if healthLost == 2 {
            bossHealthBar.texture = SKTexture(imageNamed: "healthBar402")
        }
        
        if healthLost == 3 {
            bossHealthBar.texture = SKTexture(imageNamed: "healthBar403")
        }
        
        if healthLost == 4 {
            bossHealthBar.texture = SKTexture(imageNamed: "healthBar404")
            shangTsung.removeFromParent()
            frie.removeFromParent()
            bossFight = false
            backgroundMusicPlayer.stop()
        }
        
        if sprite.position.x >= 4000 && !bossFight && shangTsung.parent != nil {
            bossFight = true
            backgroundMusicPlayer.stop()
            playBackgroundMusic("bossFight.mp3")
        }
        
        if !gameWin && sprite.position.x >= 5000 && bossFight == false {
            playBackgroundMusic("gameComplete.wav")
        }
        
        
        if (sprite.actionForKey("attacking") == nil) && (sprite.actionForKey("airattacking") == nil) {
            for i in enemies {
                if i.parent != nil {
                    if (sprite.frame.intersects(i.frame) == true) && (sprite.actionForKey("dying") == nil) && (sprite.parent != nil) && (i.actionForKey("Death") == nil) && sprite.actionForKey("hurt") == nil {
                        
                        heartsLeft--
                        
                        
                        
                        //flicker
                        let turnRed = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0.1)
                        let turnBack = SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 0.5, duration: 0.1)
                        let takeDamage = SKAction.sequence([turnRed, turnBack])
                        
                        
                        sprite.runAction(SKAction.repeatAction(takeDamage, count: 10), withKey: "hurt")
                        
                        
                        if heartsLeft == 2 {
                            heart3.alpha = 0
                            playSound(soundHurt)
                        }
                        
                        if heartsLeft == 1 {
                            playSound(soundHurt)
                            heart2.alpha = 0
                        }
                        if heartsLeft == 0 {
                            heart1.alpha = 0
                            sprite.removeAllActions()
                            world.removeAllActions()
                            sprite.runAction(SKAction.sequence([loadAnimation("striderDeath"), SKAction.removeFromParent()]), withKey: "dying")
                            gameOver.runAction(SKAction.fadeInWithDuration(1))
                            backgroundMusicPlayer.stop()
                            playBackgroundMusic("goodEnd.mp3")
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder decoder: NSCoder){
        world = SKNode()
        super.init(coder: decoder)
    }
}
