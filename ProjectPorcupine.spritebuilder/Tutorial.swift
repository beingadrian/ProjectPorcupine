//
//  Tutorial.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Tutorial: CCNode {
    
    
    func didFinishLeftStartAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("LeftLoopAnimation")
        
    }
    
    func didFinishLeftExitAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("RightStartAnimation")
        
    }
    
    func didFinishRightStartAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("RightLoopAnimation")
        
    }
    
    func didFinishRightExitAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("RemoveTutorial")
        
    }
    
    func removeTutorial() {
        
        self.removeFromParent()
        
    }

    
}
