//
//  Player.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {

  // Textures
  var textureIdle: [SKTexture] = []
  var textureWalkBody: [SKTexture] = []
    var textureWalkLegL: [SKTexture] = []
    var textureWalkLegR: [SKTexture] = []

    
    var legRNode: SKSpriteNode?
    var legLNode: SKSpriteNode?
    
  var textureJump: [SKTexture] = []
  var textureFire: [SKTexture] = []

  // Manual Movement
  var destination = CGPoint()
  let velocity: CGFloat = 250

  // States
  var jumping = false
    
    
    
    

  init() {
    self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("body") }
    self.textureWalkBody = GameManager.shared.allTextures.filter { $0.description.contains("body") }
    self.textureWalkLegL = GameManager.shared.allTextures.filter { $0.description.contains("legL") }
    self.textureWalkLegR = GameManager.shared.allTextures.filter { $0.description.contains("legR") }
    self.textureJump = GameManager.shared.allTextures.filter { $0.description.contains("jump") }
    self.textureFire = GameManager.shared.allTextures.filter { $0.description.contains("fire") }
    
    
    super.init(texture: textureIdle[0], color: .clear, size: SpriteSize.player)
    
    legRNode = SKSpriteNode(texture: textureWalkLegR[0], size: SpriteSize.player)
    legLNode = SKSpriteNode(texture: textureWalkLegL[0], size: SpriteSize.player)
    
    legRNode!.zPosition = self.zPosition + 0.01
    legLNode!.zPosition = self.zPosition - 0.01
    
    legRNode?.position = CGPoint(x: position.x + 3, y: position.y)
    legLNode?.position = CGPoint(x: position.x + 3, y: position.y)

    let animationL = SKAction.animate(with: textureWalkLegL, timePerFrame: 0.07)
    let animationR = SKAction.animate(with: textureWalkLegR, timePerFrame: 0.07)
    
    legRNode?.run(SKAction.repeatForever(animationR), withKey: "runAnim")
    legLNode?.run(SKAction.repeatForever(animationL), withKey: "runAnim")
    
    
    
    
    self.addChild(legRNode!)
    self.addChild(legLNode!)
    
    self.name = "player"
    self.texture?.filteringMode = .nearest
  }

  func setup(view: SKView) {
    self.position = CGPoint(x: view.frame.midX, y: self.size.height)
    destination = position

    // Physics
    self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
//    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
    self.physicsBody?.mass = 4.0
    self.physicsBody!.isDynamic = true
    self.physicsBody!.affectedByGravity = false
    self.physicsBody!.categoryBitMask = PhysicsMask.player
    self.physicsBody!.contactTestBitMask = PhysicsMask.mushroom
    self.physicsBody!.collisionBitMask = 0
    self.physicsBody!.restitution = 0.4

    self.animate(type: "idle")
  }

  func jump() {
    debugPrint("jump")
    jumping = true

    // Interpolation
    let animStart = SKAction.run { self.animate(type: "jump") }
    let jumpUpAction = SKAction.moveBy(x: 0, y: 100, duration: 0.2)
    let jumpDownAction = SKAction.moveBy(x: 0, y: -100, duration: 0.2)
    let animEnd = SKAction.run {
      self.animate(type: "idle")
      self.jumping = false
    }
    let jumpSequence = SKAction.sequence([animStart, jumpUpAction, jumpDownAction, animEnd])
    self.run(jumpSequence)
  }

  func walk(destination pos: CGPoint) {
    debugPrint("move")

    // Change Orientation
    let orientation: CGFloat = pos.x >= position.x ? 1.0 : -1.0
    self.xScale = fabs(self.xScale) * orientation

    
    
    // Interpolation
    let animWalk = SKAction.run {
      if (!self.jumping) { self.animate(type: "walk") }
    }
    let move = SKAction.moveTo(x: pos.x, duration: 0.3)
    move.timingMode = .easeOut
    let animIdle = SKAction.run { self.animate(type: "idle") }
    let animation = SKAction.sequence([animWalk, move, animIdle])
    self.run(animation)
  }

  func fire() {
    self.animate(type: "fire")

    let bullet = SKSpriteNode(color: SKColor.green, size: SpriteSize.bullet)
    bullet.name = "bullet"

    // Physics
    bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
    bullet.physicsBody!.isDynamic = true
    bullet.physicsBody!.affectedByGravity = false
    bullet.physicsBody!.categoryBitMask = PhysicsMask.bullet
    bullet.physicsBody!.contactTestBitMask = PhysicsMask.enemy
    bullet.physicsBody!.collisionBitMask = 0

    // Positioning
    bullet.position = CGPoint(x: position.x, y: position.y + frame.size.height / 2 + bullet.frame.size.height / 2)
    let bulletDestination = CGPoint(x: position.x,
                                    y: (parent?.frame.size.height)! + bullet.frame.size.height)

    // Animation
    let bulletAction = SKAction.sequence([
      SKAction.move(to: bulletDestination, duration: 0.6),
      SKAction.wait(forDuration: 0.2),
      SKAction.removeFromParent(),
      ])
    bullet.run(bulletAction)

    self.run(SKAction.playSoundFileNamed("fire.m4a", waitForCompletion: false))

    // Add to Scene
    parent?.addChild(bullet)
  }

  func eat(mushroom: SKNode) {
    let hud = parent?.childNode(withName: "HUD") as? HUD

    // Invalidate Collision
    mushroom.physicsBody?.categoryBitMask = 0
    mushroom.physicsBody?.contactTestBitMask = 0
    mushroom.physicsBody?.collisionBitMask = 0

    if mushroom.name == "mushroom-good" {
      hud?.score = Scores.bonus // Increase Score
      let mushroomAction = SKAction.sequence([
        SKAction.playSoundFileNamed("good.m4a", waitForCompletion: false),
        SKAction.rotate(byAngle: .pi / 2, duration: 0.5),
        SKAction.wait(forDuration: 1.0),
        SKAction.removeFromParent()
        ])
      mushroom.run(mushroomAction)
    } else {
      hud?.score = Scores.malus // Decrease Score
      let mushroomAction = SKAction.sequence([
        SKAction.playSoundFileNamed("bad.m4a", waitForCompletion: false),
        SKAction.scale(by: 0.3, duration: 0.3),
        SKAction.wait(forDuration: 1.0),
        SKAction.removeFromParent()
        ])
      mushroom.run(mushroomAction)
    }
  }

  func fireBeam() {

  }

  func setDestination(destination: CGPoint) {
    self.destination = destination
    self.animate(type: "walk")
  }

  func update(deltaTime: TimeInterval) {
    // Calculate Distance
    let distance = fabs(destination.x - position.x)

    // Change Orientation
    let orientation: CGFloat = destination.x > position.x ? 1.0 : -1.0
    self.xScale = fabs(self.xScale) 

    let trueOrientation = fabs(destination.x) - fabs(position.x)
    
    print(destination.x)
    print(position.x)
    print(orientation)
    
    
    if fabs(trueOrientation) >= 0.001{
        print("Orientation > 1")
        (legRNode?.action(forKey: "runAnim"))?.speed = 3
        (legLNode?.action(forKey: "runAnim"))?.speed = 3
        self.action(forKey: "runAnim")?.speed = 3

    }
    else{
        (legRNode?.action(forKey: "runAnim"))?.speed = AnimationSpeeds.legsMinSpeedScale
        (legLNode?.action(forKey: "runAnim"))?.speed = AnimationSpeeds.legsMinSpeedScale
        self.action(forKey: "runAnim")?.speed = AnimationSpeeds.bodyMinSpeedScale
        
    }
    
    let deltaMove = velocity * CGFloat(deltaTime)
    if (distance > deltaMove) {
      position.x += (orientation) * deltaMove
    } else if distance > 0.1 {
      position.x = destination.x
      self.animate(type: "idle")
    }
  }

  func animate(type: String) {
    var textureType: [SKTexture]
    switch type {
    case "idle":
      textureType = textureIdle
    case "walk":
      textureType = textureWalkBody
    case "jump":
      textureType = textureJump
    case "fire":
      textureType = textureFire
    default:
      textureType = textureIdle
    }
    let animation = SKAction.animate(with: textureType, timePerFrame: 0.07)
    self.run(SKAction.repeatForever(animation), withKey: "runAnim")
  }

  // Swift requires this initializer
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
