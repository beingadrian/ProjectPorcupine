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
        
        horizontalVelocity = 250
        
//        setCustomPhysicsBody()
        
        setSoftPhysicsBody()
        
    }
    
    // MARK: - Custom physics body
    
    func setCustomPhysicsBody() {
        
        // main circular body
        let mainBodyCircle = CCPhysicsShape(circleShapeWithRadius: 20, center: adjustedPos(x: 0, y: 0))
        mainBodyCircle.collisionType = "armadilloPhysicsBody"
        
        let customPhysicsBody = CCPhysicsBody(shapes: [mainBodyCircle])
        physicsBody = customPhysicsBody
        physicsBody.friction = 1.0
        physicsBody.density = 1
        
    }
    
    func setSoftPhysicsBody() {
        
        let numSegments = 10
        let physicsBodyRadius: CGFloat = 4
        let innerStiffness: CGFloat = 1500
        let innerDamping: CGFloat = 50
        let outerStiffness: CGFloat = 1000
        let outerDamping: CGFloat = 50
        
        // bubble radius is the texture half-width
        let bubbleRadius = self.contentSize.width/2
        
        // main body at the center of the bubble
        self.physicsBody = CCPhysicsBody(circleOfRadius: physicsBodyRadius, andCenter: ccp(bubbleRadius, bubbleRadius))
        self.physicsBody.allowsRotation = false
        
        // distance between main body and outer children
        let childDist = bubbleRadius - physicsBodyRadius
        
        // create child bodies connected to the main body with inner springs
        for index in 1...numSegments {
            
            let childAngle = CGFloat(index * 2 * Int(M_PI)/numSegments)
            
            let child = CCNode()
            child.physicsBody = CCPhysicsBody(circleOfRadius: physicsBodyRadius, andCenter: CGPointZero)
            child.physicsBody.allowsRotation = false
            child.physicsBody.affectedByGravity = false
            let posX = bubbleRadius + childDist * cos(childAngle)
            let posY = bubbleRadius + childDist * sin(childAngle)
            child.position = ccp(posX, posY)
            self.addChild(child)
            
            CCPhysicsJoint(springJointWithBodyA: self.physicsBody, bodyB: child.physicsBody, anchorA: ccp(bubbleRadius, bubbleRadius), anchorB: CGPointZero, restLength: childDist, stiffness: innerStiffness, damping: innerDamping)
            
        }
        
        // connect child bodies together with outer springs
        for index in 1...numSegments {
            
            let previous: CCNode = (index == 0 ? self.children[numSegments - 1] : self.children[index - 1]) as! CCNode
            let child: CCNode = self.children[1] as! CCNode
            
            let restLength = childDist * 2 * CGFloat(Int(M_PI)/numSegments)
            CCPhysicsJoint(springJointWithBodyA: child.physicsBody, bodyB: previous.physicsBody, anchorA: CGPointZero, anchorB: CGPointZero, restLength: restLength, stiffness: outerStiffness, damping: outerDamping)
            
        }
        
        
        // test
        physicsBody.velocity.x = 200
        physicsBody.affectedByGravity = false
        
        
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
