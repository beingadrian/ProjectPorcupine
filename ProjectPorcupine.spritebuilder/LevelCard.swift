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
    weak var lockOverlay: CCNodeColor!
    
    weak var star1: CCSprite!
    weak var star2: CCSprite!
    weak var star3: CCSprite!
    
    var starArray: [CCSprite] = []
    var totalStarsAwarded = 0
    
    var levelDictionary = GameManager.sharedInstance.levelDictionary as [String: [String: Int]]
    
    
    func didLoadFromCCB() {
        
        levelButton.name = self.name
        levelButton.title = "Level \(self.name.toInt()!)"
        
        starArray = [star1, star2, star3]
        
        if levelDictionary[self.name] != nil {
            totalStarsAwarded = levelDictionary[self.name]!["totalStarsAwarded"]!

            checkForUnlocked()
            
        }
        
        showStars()

        
    }
    
    func checkForUnlocked() {
        
        levelDictionary["1"]!["isUnlocked"] = 1
        
        if levelDictionary[self.name]!["isUnlocked"]! == 0 {
            levelButton.enabled = false
            lockOverlay.visible = true
        } else {
            levelButton.visible = true
            starSet.visible = true
            levelButton.enabled = true
            lockOverlay.visible = false
        }
        
        
    }
    
    func selectLevel(button: CCNode) {
        
        // play sound
        OALSimpleAudio.sharedInstance().playEffect("Assets/Audio/button_tap.wav")
        
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
        
        for i in 0..<totalStarsAwarded {
            starArray[i].opacity = 1.0
        }

        
    }
    
}
