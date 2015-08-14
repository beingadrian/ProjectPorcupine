//
//  LevelScreen.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class LevelScreen: CCNode {
    
    func backButtonPressed() {
        
        // play sound
        OALSimpleAudio.sharedInstance().playEffect("Assets/Audio/button_tap.wav")
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        // exit animation has a callback that triggers goBackToMenu()
        
    }
    
    func goBackToMenu() {
        
        parent.animationManager.runAnimationsForSequenceNamed("StartAnimation")
        self.removeFromParent()
        
    }
    
    func changeLevel() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
}
