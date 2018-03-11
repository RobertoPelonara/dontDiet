//
//  Player.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit
import CoreMotion

class Player: SKSpriteNode {
    
    // Textures
    var textureIdle: [SKTexture] = []
    var textureWalkBody: [SKTexture] = []
    var textureWalkLegL: [SKTexture] = []
    var textureWalkLegR: [SKTexture] = []
    
    //stuff
    var limit: CGFloat?
  
    
    //Physics
    var hitBox: CGRect = CGRect()
    
    var legRNode: SKSpriteNode?
    var legLNode: SKSpriteNode?
    
    var textureFire: [SKTexture] = []
    
    // Manual Movement
    var destination = CGPoint()
    let velocity: CGFloat = 1600
    
    // States
    var shooting = false
    var movingForward = false
    
    var motionManager = CMMotionManager()
    
    
    init() {
        self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("body") }
        self.textureWalkBody = GameManager.shared.allTextures.filter { $0.description.contains("body") }
        self.textureWalkLegL = GameManager.shared.allTextures.filter { $0.description.contains("legL") }
        self.textureWalkLegR = GameManager.shared.allTextures.filter { $0.description.contains("legR") }
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
        
        motionManager.deviceMotionUpdateInterval = 0.033
        motionManager.startDeviceMotionUpdates()
        
        
        self.addChild(legRNode!)
        self.addChild(legLNode!)
        
        self.name = "player"
        self.texture?.filteringMode = .nearest
    }
    
    func setup(view: SKView) {
        self.position = CGPoint(x: view.frame.midX, y: self.size.height)
        destination = position
        self.limit = view.frame.width //the boundaries of the scene
        // Physics
        hitBox = CGRect(origin: position, size: size)
        
        self.animate(type: "idle")
    }
    
    func fire() {
        
        //SPAWN THE FORK FROM THE GAME MANAGER
    
        
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
    

    func update(deltaTime: TimeInterval) {
        guard var xDeviceRotation = self.motionManager.deviceMotion?.attitude.quaternion.x else {return}
        let deviceOrientation: CGFloat = (UIDevice.current.orientation == .landscapeLeft) ?  -1.0: 1.0
        
       
        
        let orientation: CGFloat = xDeviceRotation >= 0 ? -1.0 * deviceOrientation : 1.0 * deviceOrientation
        let deltaMove = (velocity * CGFloat(sqrt(fabs(xDeviceRotation) - 0.015)) * CGFloat(deltaTime))
        
        //        UN FAVORE PLIS: QUANDO METTETE NUMERI A CASO FATE UN COMMENTO CHE SPIEGA CHE FATE
        let deltaAnim: CGFloat = CGFloat(0.5625 / ((xDeviceRotation + 1) * (xDeviceRotation + 1) * (xDeviceRotation + 1)))
        print("delta move: \(deltaMove)\ndelta anime: \(deltaAnim)")
        
        if fabs(xDeviceRotation) >= 0.015 && fabs(xDeviceRotation) <= 0.5 {
            position.x += orientation * deltaMove
            (legRNode?.action(forKey: "runAnim"))?.speed = deltaAnim
            (legLNode?.action(forKey: "runAnim"))?.speed = deltaAnim
            self.action(forKey: "runAnim")?.speed = deltaAnim
        }
        
    }
    
    func animate(type: String) {
        var textureType: [SKTexture]
        switch type {
        case "idle":
            textureType = textureIdle
        case "walk":
            textureType = textureWalkBody
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
