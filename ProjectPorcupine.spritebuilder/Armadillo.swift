//
//  Armadillo.swift
//  ProjectProcupine
//
//  Created by Adrian Wisaksana on 7/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Armadillo: Character {
    
    // constants
    let angularVelocityConstant: CGFloat = 50
    let airborneForce: CGFloat = 200
    
    // controls refrence
    var baseJoystickPosition: CGPoint?
    var topJoystickPosition: CGPoint?
    
    func didLoadFromCCB() {
        
        horizontalVelocity = 400
        
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
        let clampValue = clampf(Float(physicsBody.surfaceVelocity.x), Float(-horizontalVelocity), Float(horizontalVelocity))
        physicsBody.surfaceVelocity.x = CGFloat(clampValue)
        
        let velocityClamp = clampf(Float(physicsBody.velocity.x), -Float(horizontalVelocity), Float(horizontalVelocity))
        physicsBody.velocity.x = CGFloat(velocityClamp)
        
        // character death
        if hitPoints <= 0 && livingState == .Alive {
            livingState = .Deceased
            let gameplayScene = parent.parent as? Gameplay
            gameplayScene?.gameOver()
        }
        
        // override velocity to damp
        if verticalState == .Ground {
            physicsBody.velocity.x = 0.95 * physicsBody.velocity.x
        }
        
    }
    
    // MARK: - Armadillo movements
    
    func move() {
        
        if baseJoystickPosition != nil && topJoystickPosition != nil {
            
            // joystick calculations
            let distance = Float(ccpDistance(baseJoystickPosition!, topJoystickPosition!))
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
                            physicsBody.angularVelocity = angularVelocityConstant * velocityMultiplier
                            physicsBody.surfaceVelocity.x = -horizontalVelocity * velocityMultiplier
                        case .Right:
                            // right
                            physicsBody.angularVelocity = -angularVelocityConstant * velocityMultiplier
                            physicsBody.surfaceVelocity.x = horizontalVelocity * velocityMultiplier
                        case .None:
                            physicsBody.surfaceVelocity.x = 0
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
    
    func jumpMove() {
        
        func applyHorizontalForce(force: CGFloat) {
            physicsBody.applyForce(CGPoint(x: force, y: 0))
        }
        
        switch movementDirection {
            case .Left:
                applyHorizontalForce(-airborneForce)
            case .Right:
                applyHorizontalForce(airborneForce)
            case .None:
                stop()
            default:
                break
        }
        
    }
    
    // returns modified output distance
    func exponentialFunction(joystickDistance d: CGFloat) -> CGFloat {
        
        let outputDistance: CGFloat = pow(1.1, (0.7*d - 3))
        
        return outputDistance
        
    }
    
    
    
    
}
