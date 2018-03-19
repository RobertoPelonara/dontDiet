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
    var velocity = 0
    override func didMove(to view: SKView) {
        self.tapisRoulantTextures = GameManager.shared.allTextures.filter { $0.description.contains("tappeto") }
        //debugPrint("view: \(view.frame)")
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
        
        
        
        let gameLabel = SKLabelNode(fontNamed: "Unipix")
        gameLabel.fontSize = 80
        gameLabel.fontColor = .white
        gameLabel.text = "Don't Die"
        gameLabel.zPosition = Z.tapisRoulant
        
        addChild(gameLabel)
        
        let gameLabel2 = SKLabelNode(fontNamed: "Unipix")
        gameLabel2.fontSize = 80
        gameLabel2.fontColor = .black
        gameLabel2.text = "Don't Die"
        gameLabel2.zPosition = -0.1
        gameLabel2.position = CGPoint(x:3, y:3)
        gameLabel.addChild(gameLabel2)
        
        let tLabel = SKLabelNode(fontNamed: "Unipix")
        tLabel.fontSize = gameLabel.fontSize
        tLabel.fontColor = gameLabel.color
        tLabel.text = " t"
        tLabel.zPosition = gameLabel.zPosition
        
        addChild(tLabel)
        
        let tLabel2 = SKLabelNode(fontNamed: "Unipix")
        tLabel2.fontSize = gameLabel2.fontSize
        tLabel2.fontColor = gameLabel2.fontColor
        tLabel2.text = " t"
        tLabel2.zPosition = gameLabel2.zPosition
        addChild(tLabel2)
        
        
        
        gameLabel.position = CGPoint(x: size.width / 2 - tLabel.frame.width/2, y: size.height / 1.2)
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
        
        let bounceIn = SKAction.moveTo(y: gameLabel.position.y, duration: 0.5)
        let bounceOut = SKAction.moveTo(y: gameLabel.position.y + 50, duration: 0.5)
        
        let bounce = SKAction.sequence([bounceIn,bounceOut,bounceIn])
        idle.run(SKAction.repeatForever(sequence))
        tapToStartLabel.run(SKAction.repeatForever(fade))
        tapToStartLabel2.run(SKAction.repeatForever(fade))
        tLabel.run(bounce)
        tLabel2.run(bounce)
        //    tLabel.run(SKAction.repeatForever(fade))
        //    tLabel2.run(SKAction.repeatForever(fade))
        
        GameManager.shared.soundtrack?.volume = 0.6
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        let scene = GameScene(size: size)
        GameManager.shared.gameScene = scene
        scene.scaleMode = scaleMode
        GameManager.shared.gameViewController?.loadScene(scene, self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
    }
    
}


