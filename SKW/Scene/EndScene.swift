//
//  EndScene.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {

  override func didMove(to view: SKView) {

    backgroundColor = .white

    let bg = SKSpriteNode(color: .purple, size: CGSize(width: 200, height: 200))
    bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
    bg.zPosition = -1
    addChild(bg)
    
    let gameLabel = SKLabelNode(fontNamed: "Courier")
    gameLabel.fontSize = 80
    gameLabel.fontColor = .red
    gameLabel.text = "You Diet"
    gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
    addChild(gameLabel)
    
    let wait = SKAction.wait(forDuration: 6.0)
    let block = SKAction.run {
      GameManager.shared.gameViewController!.loadScene(GameManager.shared.menuScene!, self)
    }
    self.run(SKAction.sequence([wait, block]))

  }

}


