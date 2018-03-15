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
    
    var tapisRoulantTextures:[SKTexture] = []
    var tapisRoulantAnimation: SKAction?
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
    
    //HUD
    var hud = HUD()
    
    // Before the Scene
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx:0, dy: -9.8)
        GameManager.shared.gameScene = self
        hud.setup(size: self.size)
        self.addChild(hud)
    }
    
    override func didMove(to view: SKView) {
        self.tapisRoulantTextures = GameManager.shared.allTextures.filter { $0.description.contains("tappeto") }
        backgroundColor = .black
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = Z.background
        addChild(background)
        
        GameManager.shared.startGameTimer = Date().timeIntervalSince1970
        perna.setup(view: self.view!,gameScene:self)
        
        GameManager.shared.soundtrack?.setVolume(0.2, fadeDuration: 0.4)

        
        let tapisRoulant = SKSpriteNode(texture: tapisRoulantTextures[0], color: .clear, size: SpriteSize.tapisRoulant)
        tapisRoulant.position = CGPoint(x: self.view!.frame.midX, y: tapisRoulant.size.height/2)
         self.tapisRoulantAnimation = SKAction.repeatForever(SKAction.animate(with: tapisRoulantTextures, timePerFrame: 0.07))
        tapisRoulant.run(tapisRoulantAnimation!)
        addChild(tapisRoulant)
        
    }
    
     
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {return}
        perna.throwFork()
        
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
        if lastTime <= 0 { lastTime = currentTime }
        
        // Update delta time
        deltaTime = currentTime - lastTime
        GameManager.shared.timer = -deltaTime
        
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
        
        
    }
    
   
    
    func spawnDonut(deltaTime: TimeInterval) {
        
        spawnInterval -= deltaTime
        
        if spawnInterval <= 0 {
            let donut = GameManager.shared.getDonut()
            
            donut.setup(.big,gameScene: self)

            let spawnTime = (-3.5 * Double(GameManager.shared.score) + 15000.0)/3000.0
            spawnInterval = TimeInterval(Double(arc4random_uniform(301)) + (spawnTime * 100)) / 100
            print(spawnInterval)

            
        }
    
    }
    
}
