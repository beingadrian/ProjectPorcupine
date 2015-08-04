//
//  GameWonScreen.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class GameWonScreen: CCNode {
    
    weak var star1: CCNode!
    weak var star2: CCNode!
    weak var star3: CCNode!
    
    var starArray: [CCNode] = []
    
    var totalStarsAwarded = 0
    
    // MARK: -
    
    func didLoadFromCCB() {
        
        starArray = [star1, star2, star3]
        
        for star in starArray {
            star.visible = false
        }
        
    }
    
    // butto selector
    func loadGame() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
    func displayStars() {
        
        for i in 0..<(totalStarsAwarded) {
            starArray[i].visible = true
        }
        
    }
    
    func goToNextLevel() {
        
        GameManager.sharedInstance.currentLevel++
        loadGame()
    
    }
    
}

