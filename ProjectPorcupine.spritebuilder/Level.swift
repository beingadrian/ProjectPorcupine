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
    weak var endGoal: CCNodeGradient!
    
    
    func didLoadFromCCB() {
        
        endGoal.physicsBody.sensor = true
        
    }
    
}
