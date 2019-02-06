//
//  GameScene.swift
//  FireWorks
//
//  Created by Simon Italia on 2/4/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    
    let leftEdge = 0 - 22
    let bottomEdge = 0 - 22
    let rightEdge = 1024 + 22
    let topEdge = 768 + 22
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        //Setup scene background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Setup repating fireworks timer
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
        //Add gameScore label to scene
        createGameScore()
        
    }//End didMove() method
    
    //Create gameScore label
    func createGameScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
    }
    
    //Create Fireworks and add to Scene
    func createFirework(xMovement: CGFloat, yMovement: CGFloat, x: Int, y: Int) {
        
        //1. Create parent SKNode / container to hold firework elements
        let firework = SKNode()
        firework.position = CGPoint(x: x, y: y)
        firework.name = "firework"
        
        //2. Create rocket sprite node. This is the child node that needs to be touched for tiggering actions (colors changes, explosions, scoring etc)
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.colorBlendFactor = 1
            //Since rocket is actually white, this tells it exclusively to use one of the random colors instead
        rocket.name = "rocket"
        firework.addChild(rocket)
        
        //3. Apply a random color to rocket sprite node
        switch Int.random(in: 0...2) {
        
        case 0:
            rocket.color = .cyan
            
        case 1:
            rocket.color = .green
            
        case 2:
            rocket.color = .red
            
        default:
            break
        
        }//End switch statement
        
        //4. Create a path movement for fireworkContainer to follow
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: xMovement, y: yMovement))
        
        //5. Set fireworkContainer to follow UIBezierPath
        let fireworkMove = SKAction.follow(bezierPath.cgPath, asOffset: true, orientToPath: true, speed: 200)
            //asOffset means path coordinates are either absolute (false), or relative (true) to nodes's position
        
        firework.run(fireworkMove)
    
        //6. Apply particle emitters to rocket for lit effects
        let fuse = SKEmitterNode(fileNamed: "fuse")!
        fuse.position = CGPoint(x: 0, y: -22)
//        fuse.name = "fuse"
        firework.addChild(fuse)
        
        //7. Add firework to firework array and game scene
        fireworks.append(firework)
        addChild(firework)
        
    }//End createFirework() method
    
    @objc func launchFireworks() {
        
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...4) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, yMovement: 1000, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, yMovement: 1000, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, yMovement: 1000, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, yMovement: 1000, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, yMovement: 1000, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, yMovement: 1000, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, yMovement: 1000, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, yMovement: 1000, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, yMovement: 1000, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, yMovement: 1000, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, yMovement: 1000, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, yMovement: 1000, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, yMovement: 1000, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, yMovement: 1000, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, yMovement: 1000, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, yMovement: 1000, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, yMovement: 1000, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, yMovement: 1000, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, yMovement: 1000, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, yMovement: 1000, x: rightEdge, y: bottomEdge)
            
        case 4:
            //fire five, straight down
            createFirework(xMovement: 0, yMovement: -1000, x: 512, y: topEdge)
            createFirework(xMovement: 0, yMovement: -1000, x: 512 - 200, y: topEdge)
            createFirework(xMovement: 0, yMovement: -1000, x: 512 - 100, y: topEdge)
            createFirework(xMovement: 0, yMovement: -1000, x: 512 + 100, y: topEdge)
            createFirework(xMovement: 0, yMovement: -1000, x: 512 + 200, y: topEdge)
            
            
        //case 5:
            //fire 3 from left to right AND fire 2  from right to left
            //3 left to right
            
            
            //2 from right to left
            
            
            
            
            
            
            
            
        default:
            break

        }//End switch statement

    }//End launchFireworks() method
    
    //MARK: - Swipe to select methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    //Check where player first touched
    func checkTouches(_ touches: Set<UITouch>) {
        
        //Setup touch tracking
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: self)
        let nodesAtTouchLocation = nodes(at: touchLocation)
            //creates an Array filled with nodes at touch location
        
        //Check if touch point contains spriteNode
        for node in nodesAtTouchLocation {
            
            if node is SKSpriteNode {
                let spriteNode = node as! SKSpriteNode
                
                if spriteNode.name == "rocket" {
                    
                    //If touch point is a rocket spriteNode, ensure only one/same color spriteNode can be selected
                    for firework in fireworks {
                        let rocket = firework.children[0] as!
                        SKSpriteNode
                        
                        //If rocket spriteNode selected is not same color, reset spriteNode rockets to original color
                        if rocket.name == "rocketSelected" && rocket.color != spriteNode.color {
                            rocket.name = "rocket"
                            rocket.colorBlendFactor = 1
                        }
                        
                    }//End inner forLoop
                    
                    //Set touched rocket spriteNodes to selected
                    spriteNode.name = "rocketSelected"
                    
                    //Set touched rocket spriteNodes colorBlendFactor
                    spriteNode.colorBlendFactor = 0
                }
            }
        }//End outer forLoop

    }//End checkTouches() method
    
    //Destroy fireworks that player failed to hit when well off screen
    override func update(_ currentTime: TimeInterval) {
        
        for (index, firework) in fireworks.enumerated().reversed() {
                //remove objects from array in reverse direction (end to start of array)
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }//End update() method
    
    //Method to explode individual firework
    func explode(_ firework: SKNode) {
        
        let explosion = SKEmitterNode(fileNamed: "explode")!
        explosion.position = firework.position
//        explosion.name = "explosion"
        addChild(explosion)
        
        firework.removeFromParent()
    }
    
    //Method to explode multiple fireworks and update player score
    func explodeFireworks() {
        
        //Property to track no. of fireworks exploaded to determine player score
        var fireworksExploded = 0
        
        for (index, firework) in fireworks.enumerated().reversed() {
            let rocket = firework.children[0] as! SKSpriteNode
            
            if rocket.name == "rocketSelected" {
                
                //Destroy firework container node
                explode(firework)
                fireworks.remove(at: index)
                fireworksExploded += 1
            }
            
        }
        
        //Update player score
        switch fireworksExploded {
            
        case 0:
            break
            //0 points, since fireworks exploded by player = 0
            
        case 1:
            score += 200
            
        case 2:
            score += 500
            
        case 3:
            score += 1500
            
        case 4:
            score += 2500

        default:
            score += 4000
        }
        
    }//End explodeFireworks() method
    
}

