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

    let gameLabel2 = SKLabelNode(fontNamed: "Unipix")
    gameLabel2.fontSize = (GameManager.shared.deathReason == .outOfTime) ? 82 : 51
    gameLabel2.fontColor = .black
    gameLabel2.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
    gameLabel2.position = CGPoint(x: (size.width / 2)+1, y: size.height / 1.2)
    addChild(gameLabel2)
    let gameLabel = SKLabelNode(fontNamed: "Unipix")
    gameLabel.fontSize = (GameManager.shared.deathReason == .outOfTime) ? 80 : 50
    gameLabel.fontColor = .red
    gameLabel.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
    gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
    addChild(gameLabel)
    
    let scoreLabel = SKLabelNode(fontNamed: "Unipix")
    scoreLabel.fontSize = 40
    scoreLabel.fontColor = .black
    scoreLabel.text = "You gained \(GameManager.shared.score) calories"
    print(GameManager.shared.score)
    scoreLabel.position = CGPoint(x: gameLabel.position.x , y: gameLabel.position.y - 100)
    addChild(scoreLabel)
    
    let recordLabel = SKLabelNode(fontNamed: "Unipix")
    recordLabel.fontSize = 40
    recordLabel.fontColor = .black
    recordLabel.text = "Your highest score was \(100000) calories"
    print(GameManager.shared.score)
    recordLabel.position = CGPoint(x: scoreLabel.position.x , y: scoreLabel.position.y - 30)
    addChild(recordLabel)
    
    let timerLabel = SKLabelNode(fontNamed: "Unipix")
    timerLabel.fontSize = 35
    timerLabel.fontColor = .black
    timerLabel.text = "You have fought for \(Int(GameManager.shared.totalGameTimer)) seconds against the diet"
    timerLabel.position = CGPoint(x: gameLabel.position.x , y: scoreLabel.position.y - 100)
    addChild(timerLabel)

    
    
    
    let wait = SKAction.wait(forDuration: 2.0)
    let block = SKAction.run {
        
      GameManager.shared.gameViewController!.loadScene(GameManager.shared.menuScene!, self)
    }
    self.run(SKAction.sequence([wait, block]))

  }

}


