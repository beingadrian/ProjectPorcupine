//
//  Porcupine.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Porcupine: Character {
   
    // constants
    let angularVelocityConstant: CGFloat = 50
    let maxSurfaceVelocityX: Float = 200
    
    // controls refrence
    var baseJoystickPosition: CGPoint?
    var topJoystickPosition: CGPoint?
    
    
    func didLoadFromCCB() {
        
        horizontalVelocity = 300
        
    }
    
    // MARK: - Update function
    
    override func update(delta: CCTime) {
        
        if var baseJoystickPosition = baseJoystickPosition {
            if var topJoystickPosition = topJoystickPosition {
                move()
            }
        }
        
        // clamp horizontal velocity
        let clampValue = clampf(Float(physicsBody.velocity.x), Float(-horizontalVelocity), Float(horizontalVelocity))
        physicsBody.velocity.x = CGFloat(clampValue)
        
        // character death
        if hitPoints <= 0 && livingState == .Alive {
            livingState = .Deceased
            let gameplayScene = parent.parent as? Gameplay
            gameplayScene?.gameOver()
        }
        
    }
    
    
    // MARK - Porcupine movements
    
    func move() {
        
        if baseJoystickPosition != nil && topJoystickPosition != nil {
            
            // joystick calculations
            let distance = Float(ccpDistance(baseJoystickPosition!, topJoystickPosition!))
            let clampedDistance = CGFloat(clampf(distance, 0, 50))
            velocityMultiplier = exponentialFunction(joystickDistance: clampedDistance) / 50
            
            if topJoystickPosition!.x > baseJoystickPosition!.x {
                // right
                physicsBody.angularVelocity = -angularVelocityConstant * velocityMultiplier
                physicsBody.surfaceVelocity.x = -horizontalVelocity * velocityMultiplier
            } else if topJoystickPosition!.x < baseJoystickPosition!.x {
                // left
                physicsBody.angularVelocity =  angularVelocityConstant * velocityMultiplier
                physicsBody.surfaceVelocity.x = horizontalVelocity * velocityMultiplier
            } else {
                physicsBody.angularVelocity = 0
            }
            
        }
        
    }
    
    // returns modified output distance
    func exponentialFunction(joystickDistance d: CGFloat) -> CGFloat {
        
        let outputDistance: CGFloat = pow(1.1, (0.7*d - 3))
        
        return outputDistance
        
    }
    
    
    
    
}
