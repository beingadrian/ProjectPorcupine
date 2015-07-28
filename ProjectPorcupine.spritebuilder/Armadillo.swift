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
        
        horizontalVelocity = 1000
        
        setSoftPhysicsBody()
        
    }
    
    // MARK: - Custom physics body
    
    func setSoftPhysicsBody() {
        
        // center
        let center = CCPhysicsBody(circleOfRadius: 5, andCenter: adjustedPos(x: 0, y: 0))
        
        // constants
        let totalSegments = 12
        let childRadius: CGFloat = 5
        let mainRadius: CGFloat = 30
        let innerStiffness: CGFloat = 1500
        let innerDamping: CGFloat = 50
        let outerStiffness: CGFloat = 1000
        let outerDamping: CGFloat = 50
        let childDist: CGFloat = mainRadius - childRadius
        let childDist2: CGFloat = childDist * 2*CGFloat(M_PI)/CGFloat(totalSegments)
        
        // set inner stuff
        for i in 0..<totalSegments {
            
            // set angle
            let angle = CGFloat(i) * (2 * CGFloat(M_PI))/CGFloat(totalSegments)
            
            // create children
            let child = CCNode()
            self.addChild(child)
            child.name = String(i)
            child.position = ccp(mainRadius * cos(angle), mainRadius * sin(angle))
            child.physicsBody = CCPhysicsBody(circleOfRadius: childRadius, andCenter: adjustedPos(x: 0, y: 0))
            child.physicsBody.friction = 1
            child.physicsBody.collisionType = "armadilloPhysicsBody"
            
            // create inner springs
            CCPhysicsJoint(springJointWithBodyA: center, bodyB: child.physicsBody, anchorA: adjustedPos(x: 0, y: 0), anchorB: adjustedPos(x: 0, y: 0), restLength: childDist, stiffness: innerStiffness, damping: innerDamping)
         
        }
        
        // create outer springs
        for i in 0..<totalSegments {
            
            let currentChild: CCNode = self.children[i] as! CCNode
            var nextChild: CCNode = {
               
                if (i + 1) != 12 {
                    return self.children[i + 1] as! CCNode
                } else {
                    return self.children[0] as! CCNode
                }

            }()

            CCPhysicsJoint(springJointWithBodyA: currentChild.physicsBody, bodyB: nextChild.physicsBody, anchorA: adjustedPos(x: 0, y: 0), anchorB: adjustedPos(x: 0, y: 0), restLength: childDist2, stiffness: outerStiffness, damping: outerDamping)
            
        }
        
        physicsBody = center
        physicsBody.collisionType = "armadilloPhysicsBody"
        
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
            physicsBody.velocity.x = 0.5 * physicsBody.velocity.x
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
                            physicsBody.angularVelocity =  angularVelocityConstant * velocityMultiplier
                            physicsBody.velocity.x = -horizontalVelocity * velocityMultiplier
                        case .Right:
                            // right
                            physicsBody.angularVelocity = -angularVelocityConstant * velocityMultiplier
                            physicsBody.velocity.x = +horizontalVelocity * velocityMultiplier
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
