//
//  Collectible.swift
//  ProjectPorcupine
//
//  Created by Adrian Wisaksana on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Collectible: CCNode {
   
    func didLoadFromCCB() {
        
        physicsBody.sensor = true
        
    }
    
}
