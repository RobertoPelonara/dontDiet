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
    let velocity: CGFloat = 1300
    
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
        guard let yDeviceGravity  = self.motionManager.deviceMotion?.gravity.y else {return}
        let deviceOrientation: CGFloat = UIApplication.shared.statusBarOrientation == .landscapeLeft ? 1 : -1
        
        let orientation: CGFloat = yDeviceGravity >= 0 ? 1.0 : -1.0
        let deltaMove = velocity * CGFloat(pow((fabs(yDeviceGravity) - 0.030), 1/1.5)) * CGFloat(deltaTime) * deviceOrientation
        
        /*
         "deltaAnim" è il coefficiente che ogni frame attribuiamo alla velocità delle animazioni del personaggio per renderla proporzionale al deltaMove. C'è bisogno di sapere se il device è orientato in landscape right o left altrimenti ruotando il device l'animazione rallenta/si velocizza "al contrario", e tutti i calcoli son stati fatti per restituire valori MAI uguali o minori di 0 (altrimenti l'animazione si ferma del tutto). La logica dietro l'if/else sta nel permettere alla velocità di cambiare inversamente a seconda dell'orientation del device.
         
         speedingFunc e slowingFunc ce le siam trovate matematicamente (geogebra)
         */
        
        if fabs(yDeviceGravity) >= DeviceGravity.min {
            
            let speedingFunc = deviceOrientation == 1 ? CGFloat(0.8 + 2.2 * yDeviceGravity - pow(yDeviceGravity, 2)) : CGFloat(0.8 - 2.2 * yDeviceGravity - pow(yDeviceGravity, 2))
            let slowingFunc = deviceOrientation == 1 ? CGFloat(0.8 + yDeviceGravity  + 0.5 * pow(yDeviceGravity, 2)) : CGFloat(0.8 - yDeviceGravity + 0.5 * pow(yDeviceGravity, 2))
            
            let deltaAnim: CGFloat = CGFloat(yDeviceGravity) * deviceOrientation >= 0 ? speedingFunc : slowingFunc

//            print("orientation: \(deviceOrientation)")
//            print("delta anim: \(deltaAnim)")
//            print("gravity: \(yDeviceGravity)\n")
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
