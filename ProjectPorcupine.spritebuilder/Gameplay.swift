//
//  Gameplay.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Gameplay: CCScene {
   
    // code connections
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!
    
    // armadillo
    var armadillo: Armadillo!
    
    // controls
    weak var jumpButton: CCButton!
    var joystick: Joystick?
    var joystickEnabled = true
    var touchPosition: CGPoint?
    
    // UI
    weak var hubDisplay: HubDisplay!
    weak var gravityTimer: GravityTimer!
    weak var hurtLayer: CCNode!
    
    // hub display
    var moonCount = 0 {
        didSet {
            hubDisplay.moonCountLabel.string = "\(moonCount)/\(level.totalMoonCount)"
            hubDisplay.moonCountLabel.animationManager.runAnimationsForSequenceNamed("IncreasedCount")
        }
    }
    
    // level
    var level: Level!
    var currentLevel: Int = GameManager.sharedInstance.currentLevel
    var currentLevelPath: String {
        return "Levels/Level\(currentLevel)"
    }
    var totalStarsAwarded = 0
    
    // tutorial
    var tutorial: Tutorial?
    
    
    // MARK: - DidLoadFromCCB
    
    func didLoadFromCCB() {
        
        // remove previous textures to free up memory
        CCTextureCache.sharedTextureCache().removeAllTextures()
        
        // display FPS
        CCDirector.sharedDirector().displayStats = false
        
        // touch settings
        userInteractionEnabled = false
        jumpButton.exclusiveTouch = false
        
        gamePhysicsNode.debugDraw = false
        
        gamePhysicsNode.collisionDelegate = self
        
        loadLevel()
        
        // schedule tutorial
        if GameManager.sharedInstance.hasSeenTutorial == false {
            self.scheduleOnce("showTutorial", delay: 1)
        } else {
            userInteractionEnabled = true
        }

    }
    
    func showTutorial() {
        
        tutorial = CCBReader.load("Tutorial") as? Tutorial
        addChild(tutorial)
        
    }
    
    func loadLevel() {
        
        // load level and add to levelNode
        level = CCBReader.load(currentLevelPath) as! Level
        levelNode.addChild(level)
        
        // load armadillo
        armadillo = CCBReader.load("Entities/Characters/Armadillo") as! Armadillo
        gamePhysicsNode.addChild(armadillo)
        armadillo.position = level.startingPoint.position
        
        // update moon count label
        hubDisplay.moonCountLabel.string = "\(moonCount)/\(level.totalMoonCount)"
        
    }
    
    // MARK: - Update function
    
    override func update(delta: CCTime) {
        
        // camera follow (position override)
        let worldBoundaryRect = level.worldBoundary.boundingBox()
        let actionCameraFollow = CCActionFollow(target: armadillo, worldBoundary: worldBoundaryRect)
        gamePhysicsNode.runAction(actionCameraFollow)
        
        // jump button (instantaneous)
        if jumpButton.highlighted == true {
            jump()
            jumpButton.highlighted = false
        }
        
        // check for game over
        if armadillo.position.y < -200 {
            gameOver()
        }
        
        // star parallax
        level.starBackground.physicsBody.velocity.x = -armadillo.physicsBody.velocity.x * 0.03
        
    }
    
    // MARK: - Touch functions
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touchPosition = touch.locationInWorld()
        
        createJoystick()
        armadillo.baseJoystickPosition = joystick!.convertToNodeSpace(touchPosition!)
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touchPosition = touch.locationInWorld()
        
        // move top joystick
        if let joystick = joystick {
            
            armadillo.topJoystickPosition = joystick.convertToNodeSpace(touchPosition!)
            joystick.joystickTop.positionInPoints = armadillo.topJoystickPosition!
            
        }
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        removeJoystick()
        
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        removeJoystick()
        
    }
    
    // MARK: - Touch controls
    
    func createJoystick() {
    
        if touchPosition!.x < (boundingBox().width / 2) && joystickEnabled {
            
            joystick = CCBReader.load("Controls/Joystick") as? Joystick
            addChild(joystick)
            joystick!.positionInPoints = touchPosition!
            
        }
        
    }
    
    func removeJoystick() {
        
        if var joystick = joystick {
            armadillo.topJoystickPosition = nil
            joystick.removeFromParent()
        }
        
    }
    
    // jump button
    func jump() {
        
        armadillo.jump()
        
    }
    
    // MARK: - Gravity manipulation
    
    func initiateGravityManipulation() {
        
        // change gravity
        gamePhysicsNode.gravity.y = -300
        
        // set timer
        gravityTimer.startTimer()
        
        // return to normal gravity
        let totalSecondsCCTime = CCTime(gravityTimer.totalSeconds)
        self.scheduleOnce("finishGravityManipulation", delay: totalSecondsCCTime)
        
    }
    
    func finishGravityManipulation() {
        
        // unscheduling
        gravityTimer.stopTimer()
        
        // return to original gravity value
        gamePhysicsNode.gravity.y = -1000
        
    }
    
    // MARK: - Pause screen
    
    func pauseGame() {
        
        paused = true
        joystickEnabled = false
        let pauseScreen = CCBReader.load("PauseScreen") as! PauseScreen
        addChild(pauseScreen)
        
    }
    
    // MARK: - Game ends
    
    func gameOver() {
        
        paused = true
        animationManager.runAnimationsForSequenceNamed("GameOver")
        
    }
    
    func retryGame() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func gameWon() {
        
        paused = true
        
        animationManager.runAnimationsForSequenceNamed("GameWon")
        
        updateLevelDict()
        
        // save game
        saveGame()
        
        self.scheduleOnce("showWinningScreen", delay: 0.5)
        
    }
    
    func showWinningScreen() {
        
        let gameWonScreen = CCBReader.load("Screens/GameWonScreen", owner: self) as! GameWonScreen
        gameWonScreen.totalStarsAwarded = totalStarsAwarded
        gameWonScreen.displayStars()
        addChild(gameWonScreen)
        gameWonScreen.positionInPoints = CGPoint(x: boundingBox().width/2, y: boundingBox().height/2)
        
    }
    
    func updateLevelDict() {
        
        // calculate stars
        switch moonCount {
        case 0...(level.totalMoonCount/3):
            totalStarsAwarded = 1
        case 0...(level.totalMoonCount/3*2):
            totalStarsAwarded = 2
        case 0...(level.totalMoonCount):
            totalStarsAwarded = 3
        default:
            break
        }
        
        let nextLevel = String((level.name.toInt()!) + 1)
        
        GameManager.sharedInstance.levelDictionary[nextLevel]!["isUnlocked"] = 1
        
        let currentStarsAwarded = GameManager.sharedInstance.levelDictionary[level.name]!["totalStarsAwarded"]

        if totalStarsAwarded > currentStarsAwarded {
            GameManager.sharedInstance.levelDictionary[level.name]!["totalStarsAwarded"] = totalStarsAwarded
        }
        
    }
    
    // MARK: Save game
    
    func saveGame() {
        
        GameManager.sharedInstance.save()
        
    }
    
}

// MARK: -

extension Gameplay: CCPhysicsCollisionDelegate {
    
    // MARK: - Ground collisions
    
    func ccPhysicsCollisionPreSolve(pair: CCPhysicsCollisionPair!, jumpSensor: CCNode!, ground: CCNode!) -> Bool {
        
        armadillo.verticalState = .Ground
        
        return true
        
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, jumpSensor: CCNode!, ground: CCNode!) {
        
        // jump buffer
        armadillo.verticalState = .Airborne
        
    }
    
    // MARK: - Collectible collisions
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, collectible: Collectible!) -> Bool {
        
        // moon collectible
        if let moon = collectible as? Moon {
            moon.removeFromParent()
            moonCount++
        }
        
        // star collectible
        if let star = collectible as? Star {
            star.removeFromParent()
        }
        
        // gravity stone
        if let gravityStone = collectible as? GravityStone {
            // trigger gravity
            initiateGravityManipulation()
            
            gravityStone.removeFromParent()
        }
        
        // end goal
        if let endGoal = collectible as? EndGoal {
            endGoal.animationManager.runAnimationsForSequenceNamed("FadeOut")
        }
        
        return true
        
    }
    
    // MARK: - Trap collisions
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, obstacle: Obstacle!) -> Bool {
        
        if let deadlyObstacle = obstacle as? DeadlyObstacle {
            gameOver()
        }
        
        if let lightObstacle = obstacle as? LightObstacle {
            hurtLayer.animationManager.runAnimationsForSequenceNamed("Hurt")
        }
        
        return true
        
    }
    
   
    
}
