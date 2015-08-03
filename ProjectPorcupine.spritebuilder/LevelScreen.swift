//
//  LevelScreen.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class LevelScreen: CCNode {
    
    func hideLevelScreen() {
        
        self.removeFromParent()
        
    }
    
    func changeLevel(levelButton: CCNode) {
        
        let level = levelButton.name.toInt()
        GameManager.sharedInstance.currentLevel = level!
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
}
