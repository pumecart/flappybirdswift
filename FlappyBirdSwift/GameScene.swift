//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Pumehana Cartagena on 11/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    let pipeGap = 150.0
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        /* Setup scene here */
        
        //physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        
        //bird
        let BirdTexture = SKTexture(imageNamed: "bird1")
        BirdTexture.filteringMode = SKTextureFilteringMode.nearest
        
        bird = SKSpriteNode(texture: BirdTexture)
        bird.setScale(2.0)
        //bird.position = CGPoint(x: self.frame.size.width / 0.35, y: //self.frame.size.height / 0.6)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 150)
        //bird.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame))
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        self.addChild(bird)
        
        //ground
        
        let groundTexture = SKTexture(imageNamed: "ground")
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPoint(x: 0 - self.size.width / 2 + sprite.size.width / 2, y: 0 - self.size.height / 2 + sprite.size.height / 2)
        //sprite.position = CGPointMake(self.size.width / 2.0, sprite.size.height / 30.0)
        
        self.addChild(sprite)
        
        let ground = SKNode()
        
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
        
        
        //Pipes
        
        //Create the Pipes
        pipeUpTexture = SKTexture(imageNamed: "pipe")
        pipeDownTexture = SKTexture(imageNamed: "pipe")
        
        //movement of pipes
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        PipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Spawn Pipes
        let spawn = SKAction.run({() in self.spawnPipes()})
        let delay = SKAction.wait(forDuration: TimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        
        self.run(spawnThenDelayForever)
        
    }
    
    func spawnPipes() {
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.run(PipesMoveAndRemove)
        self.addChild(pipePair)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            
            _ = touch.location(in: self)
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 25))
            
        }
        
        func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
        }
    }
}
