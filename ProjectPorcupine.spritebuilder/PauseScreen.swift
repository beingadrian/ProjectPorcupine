//
//  PauseScreen.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class PauseScreen: CCNode {
   
    func goToMainScene() {
        
        let mainMenu = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainMenu)
        
    }
    
    func continueGame() {
        
        let gameplay = parent as? Gameplay
        gameplay!.joystickEnabled = true
        gameplay!.paused = false

        self.removeFromParent()
        
    }
    
}
