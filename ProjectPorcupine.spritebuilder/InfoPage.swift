//
//  InfoPage.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class InfoPage: CCNode {
   
    func exitInfoPage() {
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        
    }
    
    func didFinishExitAnimation() {
        
        self.removeFromParent()
        
    }
    
    
}
