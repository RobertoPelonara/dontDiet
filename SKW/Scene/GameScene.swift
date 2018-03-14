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
        let donut = Donut()
        donut.gameScene = self
        donut.setup(.big)
        GameManager.shared.spawnedDonuts.append(donut)
        addChild(donut)
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
        if lastTime <= 0 { lastTime = currentTime }
        
        // Update delta time
        deltaTime = currentTime - lastTime
        // debugPrint("\(deltaTime * 1000) milliseconds")
        
        // Set last frame time to current time
        lastTime = currentTime
        
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
        
    }
    
    
    func throwFork(){
        
        let fork = Fork()
        fork.gameScene = self
        fork.setup(playerPosition: perna.position)
        GameManager.shared.spawnedForks.append(fork)
        addChild(fork)
    }
    
}
