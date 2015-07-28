//
//  Character.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Character: CCNode {
   
    // constants
    var horizontalVelocity: CGFloat = 150
    var horizontalForce: CGFloat = 60
    var velocityMultiplier: CGFloat = 1
    var jumpPower: CGFloat = 350
    
    // health
    var hitPoints: CGFloat = 100
    
    // states
    enum LivingState {
        case Alive, Deceased
    }
    var livingState: LivingState = .Alive
    
    enum VerticalState: String {
        case Ground = "Ground", Airborne = "AirBorne"
    }
    var verticalState: VerticalState = .Airborne
    
    enum MovementDirection {
        case Left, Right, None
    }
    var movementDirection: MovementDirection = .None
    
    // running animation
    var runningSequenceName: String?
    
    
    // MARK: - Update
    
    override func update(delta: CCTime) {
        
        // character death
        if hitPoints <= 0 && livingState == .Alive {
            livingState = .Deceased
        }
        
        // update running animation
        runningSequenceName = animationManager.runningSequenceName
        
    }
    
    
    // MARK: - Character movements
    
    func jump() {
        
        if self.verticalState == .Ground {
            physicsBody.applyImpulse(CGPoint(x: 0, y: jumpPower))
        }
        
    }
    
    func stop() {
        
        physicsBody.surfaceVelocity.x = 0
        
    }
    
    func flipBodyRight(body: CCNode) {
        
        body.scaleX = 1
        
    }
    
    func flipBodyLeft(body: CCNode) {
        
        body.scaleX = -1
        
    }
    
    // MARK: - Extras
    func runAnimation(animation: String) {
        
        animationManager.runAnimationsForSequenceNamed(animation)
        
    }
    
    
    
}
