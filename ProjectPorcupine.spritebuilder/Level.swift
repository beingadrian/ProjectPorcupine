//
//  Level.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Level: CCNode {
   
    weak var startingPoint: CCNode!
    weak var worldBoundary: CCNode!
    weak var collectibles: CCNode!
    
    var totalMoonCount = 0
    
    func didLoadFromCCB() {
        
        // set moon count
        for child in collectibles.children {
            
            if let moon = child as? Moon {
                totalMoonCount++
            }
            
        }

    }
    
}
