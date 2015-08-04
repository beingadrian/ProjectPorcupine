//
//  LevelCard.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class LevelCard: CCNode {
    
    func didLoadFromCCB() {
        
        for child in children {
            
            if let button = child as? CCButton {
                button.userInteractionEnabled = true
            }
            
        }
        
    }
    
    // stars
    
}
