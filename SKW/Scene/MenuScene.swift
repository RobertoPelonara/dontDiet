//
//  MenuScene.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit
import AVKit
class MenuScene: SKScene {
    
    var tapisRoulantTextures:[SKTexture] = []
    var tapisRoulantAnimation: SKAction?
    var velocity: CGFloat = 0
    var bounceCounter = 0
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    let reflect:CGFloat = 5
    
    var tLabel = SKLabelNode(fontNamed: "Unipix")
    var tLabel2 = SKLabelNode(fontNamed: "Unipix")
    var gameLabel = SKLabelNode(fontNamed: "Unipix")
    var gameLabel2 = SKLabelNode(fontNamed: "Unipix")
    
    
    override func didMove(to view: SKView) {
        
        if GameManager.shared.infoPanel == nil {
            GameManager.shared.infoPanel = InfoPanel(sceneFrame: self.frame)
        }

        
        
        
        self.tapisRoulantTextures = GameManager.shared.allTextures.filter { $0.description.contains("tappeto") }
        backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.position = CGPoint(x: size.width/2 , y: size.height/2)
        background.zPosition = Z.background
        addChild(background)
        
        let tapisRoulant = SKSpriteNode(texture: tapisRoulantTextures[0], color: .clear, size: SpriteSize.tapisRoulant)
        tapisRoulant.position = CGPoint(x: self.view!.frame.midX, y: tapisRoulant.size.height/2)
        self.tapisRoulantAnimation = SKAction.repeatForever(SKAction.animate(with: tapisRoulantTextures, timePerFrame: 0.07))
        tapisRoulant.run(tapisRoulantAnimation!)
        tapisRoulant.zPosition = Z.tapisRoulant
        addChild(tapisRoulant)
        
        gameLabel.fontSize = 80
        gameLabel.fontColor = .white
        gameLabel.text = "Don't Die"
        gameLabel.zPosition = Z.tapisRoulant
        
        addChild(gameLabel)
        
        gameLabel2.fontSize = 80
        gameLabel2.fontColor = .black
        gameLabel2.text = "Don't Die"
        gameLabel2.zPosition = Z.tapisRoulant - 0.1
        addChild(gameLabel2)
        
        tLabel.fontSize = gameLabel.fontSize
        tLabel.fontColor = gameLabel.color
        tLabel.text = " t"
        tLabel.zPosition = gameLabel.zPosition
        
        addChild(tLabel)
        
        tLabel2.fontSize = gameLabel2.fontSize
        tLabel2.fontColor = gameLabel2.fontColor
        tLabel2.text = " t"
        tLabel2.zPosition = gameLabel2.zPosition
        addChild(tLabel2)
        
        gameLabel.position = CGPoint(x: size.width / 2 - tLabel.frame.width/2, y: size.height / 1.25) //1.2)
        gameLabel2.position = CGPoint(x:gameLabel.position.x + 3, y:gameLabel.position.y + 3)
        tLabel.position = CGPoint(x:gameLabel.position.x + gameLabel.frame.width/2 + tLabel.frame.width/2, y:size.height + tLabel.frame.height)
        tLabel2.position = CGPoint(x:tLabel.position.x + 3, y:size.height + tLabel2.frame.height)
        
        let tapToStartLabel2 = SKLabelNode(fontNamed: "Unipix")
        tapToStartLabel2.fontSize = 40
        tapToStartLabel2.fontColor = .black
        tapToStartLabel2.text = "TAP TO START"
        tapToStartLabel2.zPosition = Z.tapisRoulant + 0.1
        tapToStartLabel2.position = CGPoint(x: (size.width/2) + 3, y: tapToStartLabel2.frame.height/2 + 3)
        addChild(tapToStartLabel2)
        
        let tapToStartLabel = SKLabelNode(fontNamed: "Unipix")
        tapToStartLabel.fontSize = 40
        tapToStartLabel.fontColor = .white
        tapToStartLabel.text = "TAP TO START"
        tapToStartLabel.zPosition = Z.tapisRoulant + 0.2
        tapToStartLabel.position = CGPoint(x: size.width/2, y: tapToStartLabel.frame.height/2)
        addChild(tapToStartLabel)
        
        GameManager.shared.initializeForks()
        GameManager.shared.initializeDonuts()
        GameManager.shared.initializeBroccoli()
        
        let idle = Player()
        idle.position = CGPoint(x: size.width/2 , y:size.height/6)
        idle.zPosition = Z.player
        idle.size = SpriteSize.player
        idle.setup(view: view,gameScene: self)
        
        let positionBase = idle.position.x
        let position1 = CGPoint(x: idle.position.x - 50, y: idle.position.y)
        let position2 = CGPoint(x: idle.position.x + 50, y: idle.position.y)
        
        let action1 = SKAction.moveTo(x: position1.x, duration: 1.5)
        let action2 = SKAction.moveTo(x: positionBase, duration: 1.5)
        let action3 = SKAction.moveTo(x: position2.x, duration: 1.5)
        let action4 = SKAction.moveTo(x: positionBase, duration: 1.5)
        
        let fade = SKAction.sequence([SKAction.fadeIn(withDuration: 0.6),SKAction.fadeOut(withDuration: 0.6)])
        let sequence = SKAction.sequence([action1,action2,action3, action4])
        
        idle.run(SKAction.repeatForever(sequence))
        tapToStartLabel.run(SKAction.repeatForever(fade))
        tapToStartLabel2.run(SKAction.repeatForever(fade))

        
        GameManager.shared.soundtrack?.volume = 0.6
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastTime <= 0 { lastTime = currentTime }
        
        // Update delta time
        deltaTime = currentTime - lastTime
        lastTime = currentTime
        if bounceCounter < 2 {
            velocity += -0.3 * CGFloat(deltaTime) * 60
            tLabel.position.y += velocity * CGFloat(deltaTime) * 60
            tLabel2.position.y += velocity * CGFloat(deltaTime) * 60
            
            if tLabel2.position.y <= gameLabel.position.y {
                
                velocity = reflect
                tLabel.position.y = gameLabel.position.y
                tLabel2.position.y = gameLabel.position.y
                bounceCounter += 1
            }
            
        }
        
    }
    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let _ = touches.first else { return }
    
//    self.run(SKAction.playSoundFileNamed("good.m4a", waitForCompletion: false))
    let scene = GameScene(size: size)
    GameManager.shared.gameScene = scene
    scene.scaleMode = scaleMode
    print(scaleMode.rawValue)
//    let infoPanel = InfoPanel(sceneFrame: self.frame)
//    addChild(infoPanel)
//    infoPanel.setupEndPanel()
//    infoPanel.show()
   
    GameManager.shared.gameViewController?.loadScene(scene, self)
    velocity = 0
    bounceCounter = 0
    lastTime = 0
  }

}
