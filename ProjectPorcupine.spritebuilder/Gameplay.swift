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
    var touchPosition: CGPoint?
    
    // level
    var level: Level!
    var currentLevel: Int = 1
    var currentLevelPath: String {
        return "Levels/Level\(currentLevel)"
    }
    
    // MARK: - DidLoadFromCCB
    
    func didLoadFromCCB() {
        
        // display FPS
        CCDirector.sharedDirector().displayStats = true
        
        // touch settings
        userInteractionEnabled = true
        jumpButton.exclusiveTouch = false
        
        gamePhysicsNode.debugDraw = true
        
        gamePhysicsNode.collisionDelegate = self
        
        loadLevel()
        
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
        
    }
    
    func loadLevel() {
        
        // load level and add to levelNode
        level = CCBReader.load(currentLevelPath) as! Level
        levelNode.addChild(level)
        
        // load armadillo
        armadillo = CCBReader.load("Entities/Characters/Armadillo") as! Armadillo
        gamePhysicsNode.addChild(armadillo)
        armadillo.position = level.startingPoint.position
        
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
        
        if touchPosition!.x < (boundingBox().width / 2) {
            
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
    
    // MARK: - Game ends
    
    func gameOver() {
        
        paused = true
        let gameOverScreen = CCBReader.load("Screens/GameOverScreen", owner: self)
        addChild(gameOverScreen)
        
    }
    
    func gameWon() {
        
        paused = true
        let gameWonScreen = CCBReader.load("Screens/GameWonScreen", owner: self) as! GameWonScreen
        addChild(gameWonScreen)
        
    }
    
}

// MARK: -

extension Gameplay: CCPhysicsCollisionDelegate {
    
    // MARK: - Ground collisions
    
    func ccPhysicsCollisionPreSolve(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, ground: CCNode!) -> Bool {
        
        armadillo.verticalState = .Ground
        println("Grounded")
        
        return true
        
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, ground: CCNode!) {
        
        armadillo.verticalState = .Airborne
        
    }
    
    // MARK: - Collectible collisions
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, moon: CCNode!) -> Bool {
        
        moon.removeFromParent()
        
        return true
        
    }
    
    // MARK: - End goal collision
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, armadilloPhysicsBody: CCNode!, endGoal: CCNodeGradient!) -> Bool {
        
        endGoal.removeFromParent()
        
        gameWon()
        
        return true
        
    }
    
}
