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
    
    let gameLabel2 = SKLabelNode(fontNamed: "Unipix")
    gameLabel2.fontSize = 82
    gameLabel2.fontColor = .black
    gameLabel2.text = "Don't Die(t)"
    gameLabel2.position = CGPoint(x: (size.width / 2)+1, y: size.height / 1.2)
    addChild(gameLabel2)
    let gameLabel = SKLabelNode(fontNamed: "Unipix")
    gameLabel.fontSize = 80
    gameLabel.fontColor = .white
    gameLabel.text = "Don't Die(t)"
    gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
    addChild(gameLabel)

    let buttonStart = SKSpriteNode(imageNamed: "buttonStart-normal")
    buttonStart.name = "buttonStart"
    buttonStart.position = CGPoint(x: size.width / 2, y: size.height / 2)
    buttonStart.size = SpriteSize.button
    buttonStart.zPosition = Z.HUD
    addChild(buttonStart)
    
    GameManager.shared.initializeForks()
    GameManager.shared.initializeDonuts()
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

    let sequence = SKAction.sequence([action1,action2,action3, action4])
    idle.run(SKAction.repeatForever(sequence))
   
    GameManager.shared.soundtrack?.volume = 0.6

    
  }

  func touchDown(atPoint pos: CGPoint) {
//    debugPrint("menu down: \(pos)")
    let touchedNode = self.atPoint(pos)
    if touchedNode.name == "buttonStart" {
      let button = touchedNode as! SKSpriteNode
      button.texture = SKTexture(imageNamed: "buttonStart-pressed")
    }
  }

  func touchUp(atPoint pos: CGPoint) {
//    debugPrint("menu up: \(pos)")

    let touchedNode = self.atPoint(pos)

    if let button = childNode(withName: "buttonStart") as? SKSpriteNode {
      button.texture = SKTexture(imageNamed: "buttonStart-normal")
    }

    if touchedNode.name == "buttonStart" {
       
        self.run(SKAction.playSoundFileNamed("good.m4a", waitForCompletion: false))
      let scene = GameScene(size: size)
        GameManager.shared.gameScene = scene
      scene.scaleMode = scaleMode
        GameManager.shared.gameViewController?.loadScene(scene, self)
      
    }

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    self.touchDown(atPoint: touch.location(in: self))
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    self.touchUp(atPoint: touch.location(in: self))
  }

}
