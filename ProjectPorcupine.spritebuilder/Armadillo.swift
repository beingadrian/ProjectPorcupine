//
//  Armadillo.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Armadillo: Character {
    
    // controls refrence
    var baseJoystickPosition: CGPoint?
    var topJoystickPosition: CGPoint?
    
    func didLoadFromCCB() {
        
        // constants
        maxHorizontalVelocity = 500
        maxVerticalVelocity = 600
        angularVelocityConstant = 75
        groundForce = 1000
        airborneHorizontalForce = 300
        
        setCustomBodyPhysics()
        
    }
    
    // MARK: - Custom physics body
    
    func setCustomBodyPhysics() {
        
        // mainBody
        physicsBody = CCPhysicsBody(circleOfRadius: 20, andCenter: adjustedPos(x: 0, y: 0))
        physicsBody.collisionType = "armadilloPhysicsBody"
        physicsBody.density = 1
        physicsBody.friction = 1
        
    }
    
    func adjustedPos(#x: CGFloat, y: CGFloat) -> CGPoint {
        
        let adjustedX = x + boundingBox().width/2
        let adjustedY = y + boundingBox().height/2
        
        return CGPoint(x: adjustedX, y: adjustedY)
        
    }
    
    // MARK: - Update function
    
    override func update(delta: CCTime) {
        
        if var baseJoystickPosition = baseJoystickPosition {
            if var topJoystickPosition = topJoystickPosition {
                move()
            }
        }
        
        // clamp horizontal velocity
        let horizontalVelocityClamp = clampf(Float(physicsBody.velocity.x), -Float(maxHorizontalVelocity), Float(maxHorizontalVelocity))
        physicsBody.velocity.x = CGFloat(horizontalVelocityClamp)
        
        // clamp vertical velocity 
        let verticalVelocityClamp = clampf(Float(physicsBody.velocity.y), -Float(maxVerticalVelocity), Float(maxVerticalVelocity))
        physicsBody.velocity.y = CGFloat(verticalVelocityClamp)
        
        // character death
        if hitPoints <= 0 && livingState == .Alive {
            livingState = .Deceased
            let gameplayScene = parent.parent as? Gameplay
            gameplayScene?.gameOver()
        }
        
        // override velocity to damp
        if verticalState == .Ground {
            physicsBody.velocity.x = 0.90 * physicsBody.velocity.x
        }
        
        // test
        println(verticalState.rawValue)
        
    }
    
    // MARK: - Armadillo movements
    
    func move() {
        
        var distance: Float = 0
        
        if baseJoystickPosition != nil && topJoystickPosition != nil {
            
            // joystick calculations
            distance = Float(ccpDistance(baseJoystickPosition!, topJoystickPosition!))
            let clampedDistance = CGFloat(clampf(distance, 0, 50))
            velocityMultiplier = exponentialFunction(joystickDistance: clampedDistance) / 50
            
            // left or right adjustments
            if topJoystickPosition!.x > baseJoystickPosition!.x {
                movementDirection = .Right
            } else if topJoystickPosition!.x < baseJoystickPosition!.x {
                movementDirection = .Left
            } else {
                movementDirection = .None
            }
            
            switch verticalState {
                
                case .Ground:
                    
                    switch movementDirection {
                    case .Left:
                        // left
                        applyGroundAngularVelocity(magnitude: -angularVelocityConstant, multiplier: velocityMultiplier)
                        applyGroundForce(-groundForce)
                    
                    case .Right:
                        // right
                        applyGroundAngularVelocity(magnitude: angularVelocityConstant, multiplier: velocityMultiplier)
                        applyGroundForce(groundForce)
                    case .None:
                        physicsBody.velocity.x = 0
                    default:
                        break
                    }

                case .Airborne:
                    jumpMove()
                
                default:
                    break
            }
            
        }
        
    }
    
    // returns modified output distance
    func exponentialFunction(joystickDistance d: CGFloat) -> CGFloat {
        
        let outputDistance: CGFloat = pow(1.1, (0.7*d - 3))
        
        return outputDistance
        
    }
    
    
}
