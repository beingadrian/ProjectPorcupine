//
//  InfoPage.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class InfoPage: CCNode {
   
    weak var exitBtn: CCButton!
    
    func exitInfoPage() {
        
        exitBtn.enabled = false
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        
    }
    
    func didFinishExitAnimation() {
        
        self.removeFromParent()
        
    }
    
    
}
