//
//  LevelCard.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class LevelCard: CCNode {
    
    weak var starSet: CCNode!
    weak var levelButton: CCButton!
    
    weak var star1: CCSprite!
    weak var star2: CCSprite!
    weak var star3: CCSprite!
    
    var starArray: [CCSprite] = []
    var totalStarsAwarded = 0
    
    
    func didLoadFromCCB() {
        
        levelButton.name = self.name
        levelButton.title = "Level \(self.name.toInt()!)"
        
        starArray = [star1, star2, star3]
        
        totalStarsAwarded = GameManager.sharedInstance.levelDictionary[self.name]!["totalStarsAwarded"]!
        
        showStars()
        
    }
    
    func selectLevel(button: CCNode) {
        
        button.userInteractionEnabled = false
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        
        let levelInt = levelButton.name.toInt()!
        GameManager.sharedInstance.currentLevel = levelInt
        
    }
    
    func performFadeToBlack() {
        
        // callback calls changeLevel once animation ends
        let levelScreen = parent.parent
        levelScreen.animationManager.runAnimationsForSequenceNamed("LevelSelectedAnimation")
        
    }
    
    // stars
    func showStars() {
        
        for i in 0..<(totalStarsAwarded) {
            
            starArray[i].opacity = 1.0
            
        }
        
    }
    
}
