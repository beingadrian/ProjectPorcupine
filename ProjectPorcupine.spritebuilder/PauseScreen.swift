//
//  PauseScreen.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class PauseScreen: CCNode {
   
    weak var continueButton: CCButton!
    
    func returnToMainScene() {
        
        let mainMenu = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainMenu)
        
    }
    
    func performExitAnimation() {
        
        continueButton.enabled = false
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        
    }
    
    func continueGame() {
        
        let gameplay = parent as? Gameplay
        gameplay!.joystickEnabled = true
        gameplay!.paused = false

        self.removeFromParent()
        
    }
    
    func retryLevel() {
        
        let gameplay = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplay)
        
    }
    
}
