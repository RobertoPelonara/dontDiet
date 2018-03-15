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
    gameLabel2.fontSize = 82
    gameLabel2.fontColor = .black
    gameLabel2.text = "You Diet"
    gameLabel2.position = CGPoint(x: (size.width / 2)+1, y: size.height / 1.2)
    addChild(gameLabel2)
    let gameLabel = SKLabelNode(fontNamed: "Unipix")
    gameLabel.fontSize = 80
    gameLabel.fontColor = .red
    gameLabel.text = "You Diet"
    gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
    addChild(gameLabel)
    
    let scoreLabel = SKLabelNode(fontNamed: "Unipix")
    scoreLabel.fontSize = 40
    scoreLabel.fontColor = .black
    scoreLabel.text = "You gained \(GameManager.shared.score) calories"
    scoreLabel.position = CGPoint(x: gameLabel.position.x , y: gameLabel.position.y - 100)
    addChild(scoreLabel)
    
    let timerLabel = SKLabelNode(fontNamed: "Unipix")
    timerLabel.fontSize = 35
    timerLabel.fontColor = .black
    timerLabel.text = "You have fought for \(Int(GameManager.shared.totalGameTimer)) seconds against the diet"
    timerLabel.position = CGPoint(x: gameLabel.position.x , y: scoreLabel.position.y - 100)
    addChild(timerLabel)

    
    
    
    let wait = SKAction.wait(forDuration: 6.0)
    let block = SKAction.run {
      let scene = MenuScene(size: self.size)
      scene.scaleMode = .aspectFill
      let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
      self.view?.presentScene(scene, transition: transitionType)
    }
    self.run(SKAction.sequence([wait, block]))

  }

}


