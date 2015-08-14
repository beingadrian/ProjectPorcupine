//
//  GameWonScreen.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class GameWonScreen: CCNode {
    
    weak var homeBtn: CCButton!
    
    weak var star1: CCSprite!
    weak var star2: CCSprite!
    weak var star3: CCSprite!
    
    var starArray: [CCNode] = []
    
    var totalStarsAwarded = 0
    
    // MARK: -
    
    func didLoadFromCCB() {
        
        starArray = [star1, star2, star3]
        
    }
    
    // MARK: -
    
    // button selector
    func loadGame() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
    // MARK: -
    
    func displayStars() {
        
        for i in 0..<(totalStarsAwarded) {
            starArray[i].opacity = 1
        }
        
    }
    
    func fadeToBlack(button: CCButton) {
        
        button.enabled = false
        animationManager.runAnimationsForSequenceNamed("FadeToBlack")
        
    }
    
    func goToNextLevel() {
        
        GameManager.sharedInstance.currentLevel++
        if GameManager.sharedInstance.currentLevel != 11 {
            loadGame()
        } else {
            let mainScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().presentScene(mainScene)
        }
        
    
    }
    
    // MARK: -
    
    func retryLevel() {
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        
        loadGame()
        
    }
    
    // MARK: -
    
    func returnHome() {
    
        // play sound
        OALSimpleAudio.sharedInstance().playEffect("Assets/Audio/button_tap.wav")
        
        animationManager.runAnimationsForSequenceNamed("ExitAnimation")
        self.scheduleOnce("goToMainScene", delay: 0.5)
        
    }
    
    func goToMainScene() {
        
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
        
    }
    
}

