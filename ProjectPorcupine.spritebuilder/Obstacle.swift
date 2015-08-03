//
//  Obstacle.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Obstacle: CCNode {
   
    func didLoadFromCCB() {
        
        physicsBody.sensor = true
        physicsBody.collisionType = "obstacle"
        
    }
    
}
