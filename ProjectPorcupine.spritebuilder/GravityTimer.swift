//
//  GravityTimer.swift
//  ProjectArmadillo
//
//  Created by Adrian Wisaksana on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class GravityTimer: CCNode {
   
    weak var gravityTimerLabel: CCLabelTTF!
 
    // timer
    let totalSeconds: Int = 10
    var seconds: Int = 0 {
        didSet {
            // change text
            gravityTimerLabel.string = String(seconds)
            // perform animation
            animationManager.runAnimationsForSequenceNamed("UpdateTime")
        }
    }
    
    func didLoadFromCCB() {
        
        seconds = totalSeconds
        gravityTimerLabel.string = String(seconds)
        gravityTimerLabel.visible = false
        
    }
    
    // timer scheduler
    func startTimer() {
        
        gravityTimerLabel.visible = true
        self.schedule("updateTimer", interval: 1)
        
    }
    
    func updateTimer() {
        
        seconds--
        
    }
    
    func stopTimer() {
        
        self.unschedule("updateTimer")
        gravityTimerLabel.visible = false
        seconds = totalSeconds
        
    }
    
}
