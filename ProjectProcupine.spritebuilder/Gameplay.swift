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
    
    // level
    var level: Level!
    var currentLevel: Int = 1
    var currentLevelPath: String {
        return "Levels/Level\(currentLevel)"
    }
    
    
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
    
    
    
}
