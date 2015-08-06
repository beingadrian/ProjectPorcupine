//
//  Tutorial.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Tutorial: CCNode {
    
    weak var nextTutorialButton: CCButton!
    
    var tapCount = 0
    
    func didFinishLeftStartAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("LeftLoopAnimation")
        
    }
    
    func didFinishLeftExitAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("RightStartAnimation")
        
    }
    
    func didFinishRightStartAnimation() {
        
        animationManager.runAnimationsForSequenceNamed("RightLoopAnimation")
        nextTutorialButton.enabled = true
        
    }
    
    func nextTutorial() {
        
        tapCount++
        nextTutorialButton.enabled = false
        
        if tapCount == 1 {
            animationManager.runAnimationsForSequenceNamed("LeftExitAnimation")
        } else if tapCount == 2 {
            animationManager.runAnimationsForSequenceNamed("RemoveTutorial")
        }
        
    }
    
    func removeTutorial() {
        
        let gameplay = parent as? Gameplay
        gameplay?.userInteractionEnabled = true
        
        GameManager.sharedInstance.hasSeenTutorial = true
        
        self.removeFromParent()
        
    }

    
}
