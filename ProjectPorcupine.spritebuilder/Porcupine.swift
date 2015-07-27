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
    let airborneForce: CGFloat = 250
    
    // controls refrence
    var baseJoystickPosition: CGPoint?
    var topJoystickPosition: CGPoint?
    
    
    func didLoadFromCCB() {
        
        horizontalVelocity = 250
        
        setCustomPhysicsBody()
        
    }
    
    // MARK: - Custom physics body
    
    func setCustomPhysicsBody() {
        
        // main circular body
        let mainBodyCirclePos = CGPoint(x: boundingBox().width/2, y: boundingBox().height/2)
        let mainBodyCircle = CCPhysicsShape(circleShapeWithRadius: 20, center: mainBodyCirclePos)
        mainBodyCircle.collisionType = "porcupinePhysicsBody"
        
        let customPhysicsBody = CCPhysicsBody(shapes: [mainBodyCircle])
        physicsBody = customPhysicsBody
        physicsBody.friction = 1.0
        
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
        
        // override velocity to damp
        if verticalState == .Ground {
            physicsBody.velocity.x = 0.95 * physicsBody.velocity.x
        }

        
    }
    
    
    // MARK - Porcupine movements
    
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
                            physicsBody.angularVelocity =  angularVelocityConstant * velocityMultiplier
                            physicsBody.surfaceVelocity.x = horizontalVelocity * velocityMultiplier
                        case .Right:
                            // right
                            physicsBody.angularVelocity = -angularVelocityConstant * velocityMultiplier
                            physicsBody.surfaceVelocity.x = -horizontalVelocity * velocityMultiplier
                        case .None:
                            physicsBody.angularVelocity = 0
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
