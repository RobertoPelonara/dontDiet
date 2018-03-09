//
//  HUD.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class HUD: SKNode {

  let scoreLabel = SKLabelNode(fontNamed:"Courier")
  let timerLabel = SKLabelNode(fontNamed:"Courier")
  let buttonFire = SKSpriteNode(imageNamed: "buttonFire-normal")

  var score: Int {
    get {
      return GameManager.shared.score
    }
    set {
      GameManager.shared.score += newValue
      scoreLabel.text = "Score: \(GameManager.shared.score)"
    }
  }
  
  override init() {
    super.init()
    self.name = "HUD"

    scoreLabel.text = "Score: 0"
    scoreLabel.fontSize = 20
    scoreLabel.zPosition = Z.HUD

    timerLabel.text = "Timer: 30"
    timerLabel.fontSize = 20
    timerLabel.zPosition = Z.HUD

    buttonFire.name = "buttonFire"
    buttonFire.anchorPoint = CGPoint.zero
    buttonFire.zPosition = Z.HUD
  }

  func setup(size: CGSize) {
    let spacing: CGFloat = 10
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.position = CGPoint(x: spacing, y: size.height - scoreLabel.frame.height - spacing)
    addChild(scoreLabel)

    timerLabel.horizontalAlignmentMode = .right
    timerLabel.position = CGPoint(x: size.width - spacing, y: size.height - timerLabel.frame.height - spacing)
    addChild(timerLabel)

    buttonFire.position = CGPoint(x: 10, y: 10)
    buttonFire.size = SpriteSize.button
    addChild(buttonFire)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
