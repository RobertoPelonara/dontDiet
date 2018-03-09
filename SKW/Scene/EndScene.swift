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


