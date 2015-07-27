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
    
    // porcupine
    var porcupine: Porcupine!
    
    // controls
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
        
        gamePhysicsNode.debugDraw = false
        
        gamePhysicsNode.collisionDelegate = self
        
        loadLevel()
        
    }
    
    func loadLevel() {
        
        // load level and add to levelNode
        level = CCBReader.load(currentLevelPath) as! Level
        levelNode.addChild(level)
        
        // load porcupine
        porcupine = CCBReader.load("Entities/Characters/Porcupine") as! Porcupine
        gamePhysicsNode.addChild(porcupine)
        porcupine.position = level.startingPoint.position
        
    }
    
    // MARK: - Touch functions
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touchPosition = touch.locationInWorld()
        
        createJoystick()
        porcupine.baseJoystickPosition = joystick!.convertToNodeSpace(touchPosition!)
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        touchPosition = touch.locationInWorld()
        
        // move top joystick
        if let joystick = joystick {
            
            porcupine.topJoystickPosition = joystick.convertToNodeSpace(touchPosition!)
            joystick.joystickTop.positionInPoints = porcupine.topJoystickPosition!
            
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
            porcupine.topJoystickPosition = nil
            joystick.removeFromParent()
        }
        
    }
    
    // MARK: - Game ends
    func gameOver() {
        
        paused = true
        let gameOverScreen = CCBReader.load("GameOverScreen", owner: self) as! GameOverScreen
        addChild(gameOverScreen)
        
    }
    
    func gameWon() {
        
        paused = true
        let winningScreen = CCBReader.load("GameWonScreen", owner: self)  as! GameWonScreen
        addChild(winningScreen)
        
    }
    
    func retryGame() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
    
    
}
