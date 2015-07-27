//
//  Screen.swift
//  ProjectPorcupine
//
//  Created by Adrian Wisaksana on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Screen: CCNode {
   
    // buttons
    func retryGame() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
}
