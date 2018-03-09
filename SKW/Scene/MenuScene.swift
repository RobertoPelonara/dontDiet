//
//  MenuScene.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

  override func didMove(to view: SKView) {

    debugPrint("view: \(view.frame)")
    backgroundColor = .white

    let bg = SKSpriteNode(color: .yellow, size: CGSize(width: 100, height: 100))
    bg.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
    bg.zPosition = Z.background
    addChild(bg)

    let gameLabel = SKLabelNode(fontNamed: "Courier")
    gameLabel.fontSize = 40
    gameLabel.fontColor = .red
    gameLabel.text = "UnNamed"
    gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
    addChild(gameLabel)

    let buttonStart = SKSpriteNode(imageNamed: "buttonStart-normal")
    buttonStart.name = "buttonStart"
    buttonStart.position = CGPoint(x: size.width / 2, y: size.height / 2.8)
    buttonStart.size = SpriteSize.button
    buttonStart.zPosition = Z.HUD
    addChild(buttonStart)

    let perna = SKSpriteNode(imageNamed: "perna")
    perna.position = CGPoint(x: size.width / 2, y: size.height / 6)
    perna.setScale(1.5)
    perna.texture?.filteringMode = .nearest
    perna.zPosition = Z.sprites
    addChild(perna)
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
      scene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
      view?.presentScene(scene, transition: transitionType)
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
