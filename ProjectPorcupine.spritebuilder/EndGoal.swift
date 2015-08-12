//
//  EndGoal.swift
//  ProjectPorcupine
//
//  Created by Adrian Wisaksana on 7/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class EndGoal: Collectible {
    
    func didFinishFadeOut() {
        
        let gameplayScene = (parent.parent.parent.parent as? Gameplay)
        gameplayScene?.gameWon()
        self.removeFromParent()
        
    }
    
}
