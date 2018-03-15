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
    var textureWalkXS: [SKTexture] = []
    var textureWalkFat: [SKTexture] = []
    var textureWalkNormal: [SKTexture] = []
    var textureWalkSlim: [SKTexture] = []
    var textureWalkLegL: [SKTexture] = []
    var textureWalkLegR: [SKTexture] = []
    var textureThrowFat: [SKTexture] = []
    var textureThrowNormal: [SKTexture] = []
    var textureThrowSlim: [SKTexture] = []
    var textureThrowXS: [SKTexture] = []
    
    //Sounds
    var throwSound: SKAction?
    var eatSound: SKAction?
    
    var hasPowerUp = true
    
    var fatIdle: SKAction?
    var normalIdle: SKAction?
    var slimIdle: SKAction?
    var xsIdle: SKAction?
    
    //stuff
    var limit: CGFloat?
    
    var gameScene: SKScene?
    
    //Physics
    var hitBox: Rect?
    var debugHitBox: SKSpriteNode?
    
    var legRNode: SKSpriteNode?
    var legLNode: SKSpriteNode?
    
    var textureFire: [SKTexture] = []
    
    // Manual Movement
    var destination = CGPoint()
    let velocity: CGFloat = 1300
    
    // States
    var shooting = false
    var movingForward = false
    var fatState: FatState = .fat
    
    var motionManager = CMMotionManager()
    
    //constraints for player
    var rangeUpperLimit: CGFloat?
    var rangeLowerLimit: CGFloat?
    
    enum FatState {
        case xs
        case slim
        case normal
        case fat
    }
    
    private var debug = false
    
    init() {
        self.textureWalkFat = GameManager.shared.allTextures.filter { $0.description.contains("run_fat") }
        self.textureWalkNormal = GameManager.shared.allTextures.filter { $0.description.contains("run_normal") }
        self.textureWalkSlim = GameManager.shared.allTextures.filter { $0.description.contains("run_slim") }
        self.textureWalkXS = GameManager.shared.allTextures.filter { $0.description.contains("run_XS") }
        self.textureWalkLegL = GameManager.shared.allTextures.filter { $0.description.contains("legL") }
        self.textureWalkLegR = GameManager.shared.allTextures.filter { $0.description.contains("legR") }
        self.textureThrowFat = GameManager.shared.allTextures.filter { $0.description.contains("fork_fat") }
        self.textureThrowNormal = GameManager.shared.allTextures.filter { $0.description.contains("fork_normal") }
        self.textureThrowSlim = GameManager.shared.allTextures.filter { $0.description.contains("fork_slim") }
        self.textureThrowXS = GameManager.shared.allTextures.filter { $0.description.contains("fork_XS") }
        
        self.fatIdle = SKAction.repeatForever(SKAction.animate(with: textureWalkFat, timePerFrame: 0.07))
        self.normalIdle = SKAction.repeatForever(SKAction.animate(with: textureWalkNormal, timePerFrame: 0.07))
        self.slimIdle = SKAction.repeatForever(SKAction.animate(with: textureWalkSlim, timePerFrame: 0.07))
        self.xsIdle = SKAction.repeatForever(SKAction.animate(with: textureWalkXS, timePerFrame: 0.07))
        
        self.throwSound = SKAction.playSoundFileNamed("throwFork.wav", waitForCompletion: false)
       
        
        super.init(texture: textureWalkFat[0], color: .clear, size: SpriteSize.player)
        
        legRNode = SKSpriteNode(texture: textureWalkLegR[0], size: SpriteSize.player)
        legLNode = SKSpriteNode(texture: textureWalkLegL[0], size: SpriteSize.player)
        
        legRNode!.zPosition = self.zPosition + 0.01
        legLNode!.zPosition = self.zPosition - 0.01
        
        legRNode?.position = CGPoint(x: 8, y: -12)
        legLNode?.position = CGPoint(x: 8, y: -12)
        
        let animationL = SKAction.animate(with: textureWalkLegL, timePerFrame: 0.07)
        let animationR = SKAction.animate(with: textureWalkLegR, timePerFrame: 0.07)
        
        legRNode?.run(SKAction.repeatForever(animationR), withKey: "runAnim")
        legLNode?.run(SKAction.repeatForever(animationL), withKey: "runAnim")
        
        motionManager.deviceMotionUpdateInterval = 0.033
        motionManager.startDeviceMotionUpdates()
        
        legLNode?.setScale(1.3)
        legRNode?.setScale(1.3)
        
        self.addChild(legRNode!)
        self.addChild(legLNode!)
        
        self.name = "player"
        self.texture?.filteringMode = .nearest
    }
    
    func setup(view: SKView, gameScene:SKScene) {
        
        self.setScale(0.75)
        self.gameScene = gameScene
        self.position = CGPoint(x: view.frame.midX, y: self.size.height/2 + GameManager.shared.groundY + 8)
        self.zPosition = Z.player
        destination = position
        self.rangeLowerLimit = 0.0 + SpriteSize.player.width / 2
        self.rangeUpperLimit = view.frame.width - SpriteSize.player.width / 2 //the boundaries of the scene
        // Physics
        hitBox = Rect(x: position.x, y: position.y - 5, height: 48, width: 23)
        
        let range = SKRange(lowerLimit: rangeLowerLimit!, upperLimit: rangeUpperLimit!)
        let stattFerm = [SKConstraint.positionX(range)]
        self.constraints = stattFerm
        
        if debug{
            debugHitBox = SKSpriteNode(color: UIColor.white, size: CGSize(width: 23 , height: 48))
            debugHitBox?.position = position
            debugHitBox?.position.y -= 5
            debugHitBox?.zPosition = Z.HUD
            gameScene.addChild(debugHitBox!)
            
        }
        
        self.run((fatIdle!), withKey: "runAnim")
        
        gameScene.addChild(self)
    }
    
    func throwFork(){
        
        let maximumForks = self.hasPowerUp ? 2 : 1
        
        if GameManager.shared.spawnedForks.count < maximumForks {
            
            let fork = GameManager.shared.getFork()
            fork.setup(playerPosition: self.position,gameScene: self.gameScene!)
            
            self.run(shootAnimation())
            
        } else {return}
        
    }
    
    func update(deltaTime: TimeInterval) {
        
        updateMoveAndAnim(deltaTime)
        updateHitBox()
        checkCollisionWithDonuts()
        
    }
    
    func updateHitBox () {
        
        hitBox!.x = position.x
        hitBox!.y = position.y - 5
        debugHitBox?.position.x = hitBox!.x
        debugHitBox?.position.y = hitBox!.y - 5
        
    }
    
    func checkCollisionWithDonuts () {
        
        for donut in GameManager.shared.spawnedDonuts {
            if rectInCircle(rect: hitBox!, circle: donut.hitBox!){
                
                var shouldDie = false
                switch donut.type!{
                case .big:
                    shouldDie = true
                case .mediumLeft:
                    shouldDie = true
                case .mediumRight:
                    shouldDie = true
                case .smallLeft:
                    break
                case .smallRight:
                    break
                }
                if shouldDie{

                    GameManager.shared.gameOver()
                    removeFromParent()
                    hitBox = nil
                    
                    return
                }
                
                GameManager.shared.addScore()
                GameManager.shared.addFat()
                donut.hit()
            }
        }
    }
    
    func checkFat() {
        
        switch self.fatState {
        case .fat:
            if GameManager.shared.timer <= FatTimer.normalThreshold {self.setFatLevel(.normal)}
        case .normal:
            if GameManager.shared.timer > FatTimer.normalThreshold {self.setFatLevel(.fat)} else if GameManager.shared.timer <= FatTimer.slimThreshold {self.setFatLevel(.slim)}
        case .slim:
            if GameManager.shared.timer > FatTimer.slimThreshold {self.setFatLevel(.normal)} else if GameManager.shared.timer <= FatTimer.xsThreshold {self.setFatLevel(.xs)}
        case .xs:
            if GameManager.shared.timer > FatTimer.xsThreshold {self.setFatLevel(.slim)} else if GameManager.shared.timer <= 0 {GameManager.shared.gameOver()}
        }
    }
    
    func updateMoveAndAnim (_ deltaTime: TimeInterval){
        
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
        
        self.checkFat()
    }
    
    func shootAnimation() -> SKAction {
        
        var idle: SKAction
        var textureThrow: [SKTexture]
        switch self.fatState {
        case .fat:
            idle = fatIdle!
            textureThrow = textureThrowFat
        case .normal:
            idle = normalIdle!
            textureThrow = textureThrowNormal
        case .slim:
            idle = slimIdle!
            textureThrow = textureThrowSlim
        case .xs:
            idle = xsIdle!
            textureThrow = textureThrowXS
        }
        
        let shoot = SKAction.animate(with: textureThrow, timePerFrame: 0.3)
        self.run(self.throwSound!)
        return SKAction.sequence([shoot, idle])
        
    }
    
    func setFatLevel(_ type: FatState) {
        self.fatState = type
        
        print("prima gamba: \(legRNode?.position)")
        switch type {
        case .fat:
            self.run((fatIdle!), withKey: "runAnim")
            legRNode?.position = CGPoint(x: 8, y: -12)
            legLNode?.position = CGPoint(x: 8, y: -12)
        case .normal:
            self.run((normalIdle!), withKey: "runAnim")
            legRNode?.position = CGPoint(x: 5, y: -12)
            legLNode?.position = CGPoint(x: 5, y: -12)
        case .slim:
            self.run((slimIdle!), withKey: "runAnim")
            legRNode?.position = CGPoint(x: 5, y: -12)
            legLNode?.position = CGPoint(x: 5, y: -12)
        case .xs:
            self.run((xsIdle!), withKey: "runAnim")
            legRNode?.position = CGPoint(x: 3, y: -12)
            legLNode?.position = CGPoint(x: 3, y: -12)
        }
        print("dopo gamba: \(legRNode?.position)")
    }
    
    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


