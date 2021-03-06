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
    
    //tapis roulant node
    var tapisRoulant = SKSpriteNode()
    
    // Special
    var donut: Donut? = nil
    var debugHitBox: SKSpriteNode?
    
    // Gesture
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    let triggerDistance: CGFloat = 20
    var initialTouch: CGPoint = CGPoint.zero
    
    //Overdose
    var defaultRushTimer = 5.0
    var rushTimer = 5.0
    var rushCount = 0
    var donutToOverdose = 3
    var defaultOverdoseTimer = 7.0
    var overdoseTimer = 7.0
    
    var overdoseEndingSequence: SKAction?
    let backgroundOverdoseAction = SKAction.repeat(SKAction.animate(with: GameManager.shared.backgroundOverdoseTextures, timePerFrame: 0.15), count: 5)
    
    //HUD
    var hud = HUD()
    var background: SKSpriteNode?
    
    override func sceneDidLoad() {
        GameManager.shared.gameScene = self
        hud.setup(size: self.size)
        self.addChild(hud)
    }
    
    override func didMove(to view: SKView) {
        
        if GameManager.shared.firstTime {
            print("Show Tutorial")
            GameManager.shared.gamePaused = true

            GameManager.shared.infoPanel?.setupTutorial()
            addChild(GameManager.shared.infoPanel!)
            addChild(GameManager.shared.infoPanel!.fade)
            GameManager.shared.infoPanel!.fade.zPosition = GameManager.shared.infoPanel!.zPosition - 0.001
            GameManager.shared.infoPanel!.fade.position = CGPoint(x: size.width/2, y: size.height/2)
            GameManager.shared.infoPanel?.show()

        }
        
        
        DonutConstants.Reflect.big = (DonutConstants.MaxHeight.big - (groundY + SpriteSize.donutBig.height/2) - (0.5 * DonutConstants.gravity.y * pow(0.63, 2))) / 0.63
        DonutConstants.Reflect.medium = (DonutConstants.MaxHeight.medium - (groundY + SpriteSize.donutMid.height / 2) - (0.5 * DonutConstants.gravity.y * pow(0.516, 2))) / 0.516
        DonutConstants.Reflect.small = (DonutConstants.MaxHeight.small - (groundY + SpriteSize.donutSmall.height / 2) - (0.5 * DonutConstants.gravity.y * pow(0.3999, 2))) / 0.3999
        
        self.tapisRoulantTextures = GameManager.shared.allTextures.filter { $0.description.contains("tappeto") }
        backgroundColor = .black
        background = SKSpriteNode(imageNamed: "background")
        background!.size = frame.size
        background!.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background!.zPosition = Z.background
        addChild(background!)
        
        GameManager.shared.startGameTimer = Date().timeIntervalSince1970
        
        perna.setup(view: self.view!,gameScene:self)
        
        print(perna.size)
        GameManager.shared.soundtrack?.setVolume(0.2, fadeDuration: 0.4)
        
        
        tapisRoulant = SKSpriteNode(texture: tapisRoulantTextures[0], color: .clear, size: SpriteSize.tapisRoulant)
        tapisRoulant.position = CGPoint(x: self.frame.midX, y: tapisRoulant.size.height/2)
        self.tapisRoulantAnimation = SKAction.repeatForever(SKAction.animate(with: tapisRoulantTextures, timePerFrame: 0.07))
        tapisRoulant.run(tapisRoulantAnimation!)
        tapisRoulant.zPosition = Z.tapisRoulant
        addChild(tapisRoulant)
        
        groundY = tapisRoulant.position.y + tapisRoulant.frame.height/2
        
        let overdoseEndingAction = SKAction.run {
            GameManager.shared.overdoseStarted = false
            self.overdoseTimer = self.defaultOverdoseTimer
            self.endOverdose()
        }
        
        overdoseEndingSequence = SKAction.sequence([self.backgroundOverdoseAction, overdoseEndingAction])
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !GameManager.shared.gamePaused {
            guard let _ = touches.first else {return}
            perna.throwFork()
        }
        else {
            if GameManager.shared.infoPanel!.isShown {
                if  GameManager.shared.infoPanel!.isEndPanel {
                    let nodeFound = nodes(at: (touches.first?.location(in: self))!).first
                    
                    if let node = nodeFound {
                        
                        if node.name == "buttonHome"{
                            GameManager.shared.infoPanel?.goToMainMenu()
                        }
                        else if node.name == "buttonRestart" {
                            GameManager.shared.infoPanel?.restartGame()
                        }
                    }
                    return
                } else {
                    GameManager.shared.firstTime = false
                }
                GameManager.shared.infoPanel?.hide()
                GameManager.shared.gamePaused = false
                
            }
        }
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        if !GameManager.shared.gamePaused {
            
            // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
            if lastTime <= 0 { lastTime = currentTime }
            
            // Update delta time
            deltaTime = currentTime - lastTime
            
            if GameManager.shared.rushStarted {
                rushTimer -= deltaTime
                if rushTimer <= 0 {
                    GameManager.shared.rushStarted = false
                    rushTimer = defaultRushTimer
                    rushCount = 0
                }
            }
            if GameManager.shared.overdoseStarted {
                overdoseTimer -= deltaTime
                if overdoseTimer <= 0 && !GameManager.shared.overdoseEnding {
                    GameManager.shared.overdoseEnding = true
                    background?.run(overdoseEndingSequence!)
                }
            }
            
            
            
            GameManager.shared.timer = -deltaTime
            
            // Random spawn
            spawnDonut(deltaTime: deltaTime)
            spawnBroccoli(deltaTime: deltaTime)
            
            // Set last frame time to current time
            lastTime = currentTime
            
            // Set the Refletc parameter of the donuts
            
           
            
            for donut in GameManager.shared.spawnedDonuts {
                donut.update(deltaTime: deltaTime)
            }
            for fork in GameManager.shared.spawnedForks {
                fork.update(deltaTime: deltaTime)
            }
            for broccoli in GameManager.shared.spawnedBroccoli {
                broccoli.update(deltaTime: deltaTime)
            }
            
        }
        
        perna.update(deltaTime: deltaTime)
        
    }
    
    
    func startOverdose () {
        
        background?.texture = SKTexture(image: #imageLiteral(resourceName: "backgroundOverdose"))
        GameManager.shared.overdoseStarted = true
        GameManager.shared.rushStarted = false
        rushCount = 0
        
        for donut in GameManager.shared.spawnedDonuts {
            if donut.type == .big {
                donut.auraNode?.run(DonutsActions.bigAuraAnim)
            } else if donut.type == .mediumLeft || donut.type == .mediumRight {
                donut.auraNode?.run(DonutsActions.midAuraAnim)
            }
        }
        
    }
    
    func endOverdose () {
        
        background?.texture = SKTexture(image: #imageLiteral(resourceName: "background"))
        GameManager.shared.overdoseEnding = false
        
        for donut in GameManager.shared.spawnedDonuts {
            if donut.type != .smallLeft && donut.type != .smallRight {
                donut.auraNode?.removeAllActions()
                donut.auraNode?.texture = nil
            }
        }
        
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
