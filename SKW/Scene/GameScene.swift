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
    var spawnDonutInterval: TimeInterval = 2
    
    // Broccoli spawn Timer
    var spawnBroccoliInterval: TimeInterval = 15
    
    
    
    // Special
    var donut: Donut? = nil
    var debugHitBox: SKSpriteNode?
    // Gesture
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    let triggerDistance: CGFloat = 20
    var initialTouch: CGPoint = CGPoint.zero
    
    //Overdose
    var rushStarted = false
    var defaultRushTimer = 5.0
    var rushTimer = 5.0
    var rushCount = 0
    var donutToOverdose = 5
    var defaultOverdoseTimer = 7.0
    var overdoseTimer = 7.0
    var overdoseStarted = false
    
    
    //HUD
    var hud = HUD()
    var background: SKSpriteNode?
    
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
        background = SKSpriteNode(imageNamed: "background")
        background!.size = frame.size
        background!.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background!.zPosition = Z.background
        addChild(background!)
        
        GameManager.shared.startGameTimer = Date().timeIntervalSince1970
        perna.setup(view: self.view!,gameScene:self)
        
        GameManager.shared.soundtrack?.setVolume(0.2, fadeDuration: 0.4)

        
        let tapisRoulant = SKSpriteNode(texture: tapisRoulantTextures[0], color: .clear, size: SpriteSize.tapisRoulant)
        tapisRoulant.position = CGPoint(x: self.view!.frame.midX, y: tapisRoulant.size.height/2)
         self.tapisRoulantAnimation = SKAction.repeatForever(SKAction.animate(with: tapisRoulantTextures, timePerFrame: 0.07))
        tapisRoulant.run(tapisRoulantAnimation!)
        tapisRoulant.zPosition = Z.tapisRoulant
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
       
        
        if rushStarted {
            rushTimer -= deltaTime
            if rushTimer <= 0 {
                rushStarted = false
                rushTimer = defaultRushTimer
                rushCount = 0
            }
        }
        if overdoseStarted {
            overdoseTimer -= deltaTime
            if overdoseTimer <= 0 {
                overdoseStarted = false
                overdoseTimer = defaultOverdoseTimer
                endOverdose()
            }
        }

        GameManager.shared.timer = -deltaTime
        
        // Random spawn
        spawnDonut(deltaTime: deltaTime)
        spawnBroccoli(deltaTime: deltaTime)
        
        // Set last frame time to current time
        lastTime = currentTime
        
//        print(GameManager.shared.spawnedDonuts.count)
        for donut in GameManager.shared.spawnedDonuts {
            donut.update(deltaTime: deltaTime)
        }
        
        for fork in GameManager.shared.spawnedForks {
            fork.update(deltaTime: deltaTime)
        }
        
        for broccoli in GameManager.shared.spawnedBroccoli {
            broccoli.update(deltaTime: deltaTime)
        }
        
        perna.update(deltaTime: deltaTime)
        debugHitBox?.position.x = perna.hitBox!.x
        debugHitBox?.position.y = perna.hitBox!.y
        
        
    }
    
   
    func startOverdose () {
        background?.texture = SKTexture(image: #imageLiteral(resourceName: "backgroundOverdose"))
        overdoseStarted = true
        rushStarted = false
        rushCount = 0
    }
    
    func endOverdose () {
        background?.texture = SKTexture(image: #imageLiteral(resourceName: "background"))
    }
    func spawnDonut(deltaTime: TimeInterval) {
        
        spawnDonutInterval -= deltaTime
        
        if spawnDonutInterval <= 0 {
            
            let donut = GameManager.shared.getDonut()
            
            donut.setup(.big,gameScene: self)
            
            if GameManager.shared.score >= 3000 {
                
                spawnDonutInterval = TimeInterval(Double(arc4random_uniform(301)) + (1.5 * 100)) / 100
                
            } else {
                
                let spawnTime = (-3.5 * Double(GameManager.shared.score) + 15000.0)/3000.0
                
                spawnDonutInterval = TimeInterval(Double(arc4random_uniform(301)) + (spawnTime * 100)) / 100
            
                
            }
            
        }
        
    }
    
    func spawnBroccoli(deltaTime: TimeInterval) {
        
        spawnBroccoliInterval -= deltaTime
        
        if spawnBroccoliInterval <= 0 {
            
            let broccoli = GameManager.shared.getBroccoli()
            
            broccoli.setup(gameScene: self)
            
            if GameManager.shared.score >= 3000 {
    
                  spawnBroccoliInterval = TimeInterval(Double(arc4random_uniform(1001)) + (5 * 100)) / 100
                
            } else{
                
                let spawnTime = (-15 * Double(GameManager.shared.score) + 60000.0)/3000.0
                spawnBroccoliInterval = TimeInterval(Double(arc4random_uniform(1001)) + (spawnTime * 100)) / 100
                
            }

            
        }
        
    }
    
}
