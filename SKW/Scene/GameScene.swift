//
//  GameScene.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    // Actors
    var perna = Player()
    let enemies = (rows: 3, cols: 12)
    
    // Update Timer
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    
    // Donut spawn Timer
    var lastDonutTime: TimeInterval = 0
    var timeFromLastDonut: TimeInterval = 0
    var spawnInterval: TimeInterval = 2
    
    // Special
    var donut: Donut? = nil
    var debugHitBox: SKSpriteNode?
    // Gesture
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    let triggerDistance: CGFloat = 20
    var initialTouch: CGPoint = CGPoint.zero
    
    
    
    // Before the Scene
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx:0, dy: -9.8)
        
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = Z.background
        addChild(background)
        
        perna.gameScene = self
        perna.setup(view: self.view!)
        addChild(perna)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {return}
        throwFork()
        
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
        if lastTime <= 0 { lastTime = currentTime }
        
        // Update delta time
        deltaTime = currentTime - lastTime
        
        // Random spawn
        spawnDonut(deltaTime: deltaTime)
        
        // Set last frame time to current time
        lastTime = currentTime
        
//        print(GameManager.shared.spawnedDonuts.count)
        for donut in GameManager.shared.spawnedDonuts {
            donut.update(deltaTime: deltaTime)
        }
        
        for fork in GameManager.shared.spawnedForks {
            fork.update(deltaTime: deltaTime)
        }
        
        perna.update(deltaTime: deltaTime)
        debugHitBox?.position.x = perna.hitBox!.x
        debugHitBox?.position.y = perna.hitBox!.y
        //    checkSimpleCollision()
        
        print("spawned donuts: \(GameManager.shared.spawnedDonuts.count) - spawned forks: \(GameManager.shared.spawnedForks.count)\navailable donuts: \(GameManager.shared.availableDonuts.count) - available forks: \(GameManager.shared.availableForks.count)")
    }
    
    func spawnDonut(deltaTime: TimeInterval) {
        
        spawnInterval -= deltaTime
        
        if spawnInterval <= 0 {
            let donut = GameManager.shared.getDonut()
            donut.gameScene = self
            donut.setup(.big)

            addChild(donut)
            
            spawnInterval = TimeInterval(arc4random_uniform(101) + 300) / 100
//            print(spawnInterval)
        }
    
    }
    
    func throwFork(){
        
        let maximumForks = perna.hasPowerUp ? 2 : 1
        
        if GameManager.shared.spawnedForks.count < maximumForks {
            
            let fork = GameManager.shared.getFork()
            fork.gameScene = self
            fork.setup(playerPosition: perna.position)
//            print(GameManager.shared.spawnedForks)
            addChild(fork)
            
        } else {return}
        
    }
    
}
