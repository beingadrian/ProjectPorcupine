//
//  Character.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Character: CCNode {
   
    // constants
    var maxHorizontalVelocity: CGFloat = 150
    var maxVerticalVelocity: CGFloat = 300
    var angularVelocityConstant: CGFloat = 75
    var groundForce: CGFloat = 1000
    var velocityMultiplier: CGFloat = 1
    var airborneHorizontalForce: CGFloat = 200
    var jumpPower: CGFloat = 450
    
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
    
    // MARK: –– Horizontal movements
    
    func applyGroundForce(force: CGFloat) {
        
        physicsBody.applyForce(CGPoint(x: force, y: 0))
        
    }
    
    func applyGroundAngularVelocity(#magnitude: CGFloat, multiplier: CGFloat) {
        
        physicsBody.angularVelocity = -magnitude * multiplier
        
    }
    
    // MARK: –– Jumping
    
    func jump() {
        
        if self.verticalState == .Ground {
            physicsBody.applyImpulse(CGPoint(x: 0, y: jumpPower))
        }
        
    }
    
    func jumpMove() {
        
        func applyHorizontalForce(force: CGFloat) {
            physicsBody.applyForce(CGPoint(x: force, y: 0))
        }
        
        switch movementDirection {
        case .Left:
            applyHorizontalForce(-airborneHorizontalForce)
        case .Right:
            applyHorizontalForce(airborneHorizontalForce)
        default:
            break
        }
        
    }
    
    // MARK: –– Body flips
    
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
