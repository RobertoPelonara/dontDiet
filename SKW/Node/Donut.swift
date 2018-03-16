//
//  Donut.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import SpriteKit

class Donut: SKSpriteNode {
    
    var hitBox: Circle?
    var debugHitBox: SKShapeNode?
    var xParameter: CGFloat?
    var reflectParameter: CGFloat?
    var indexInArray: Int?
    var type: DonutType?
//    var isInGame:Bool = false
    
    //costante per il deltaTime: tarato sui 60fps, quindi avrà valore 60 (velocity * deltaTime = 1)
    let velocity: CGFloat = 60
    
    //counter per rimbalzi piccole
    var counter: Int = 0
    
    //animazione minidonut
    let pulseWhite = SKAction.sequence([
        SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2),
        SKAction.wait(forDuration: 0.2),
        SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)])
    
    enum DonutType {
        case big
        case mediumLeft
        case mediumRight
        case smallLeft
        case smallRight
    }
    
    var debug = false
    var currForce = Vector2(x: 0, y: 0)
    
    var gameScene: SKScene?
    
    init() {
        super.init(texture: nil, color: .clear, size: .zero)
    }
    
    func setup (_ type: DonutType, gameScene: SKScene, spawnPosition: CGPoint? = nil) {
        
        self.gameScene = gameScene
        self.type = type
        
        if type == .big {bigDonutSetup()}
        if type == .mediumLeft || type == .mediumRight {mediumDonutSetup(spawnPosition!)}
        if type == .smallLeft || type == .smallRight {smallDonutSetup(spawnPosition!)}
        
        if debug{
            debugHitBox = SKShapeNode(circleOfRadius: hitBox!.r)
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene.addChild(debugHitBox!)
        }
        
        GameManager.shared.spawnedDonuts.append(self)
        
    }
    
    func bigDonutSetup() {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allBigDonutsTextures.count)))
        self.texture = GameManager.shared.allBigDonutsTextures[rand]
        self.color = .clear
        self.size = SpriteSize.donutBig
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutBig.width/2)
        
        reflectParameter = DonutConstants.Reflect.big
        xParameter = DonutConstants.XMovement.big
        
        self.position = self.randomPositionSpawn()
        
        gameScene?.addChild(self)
    }
    
    func mediumDonutSetup(_ spawnPosition: CGPoint) {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allMediumDonutsTextures.count)))
        self.texture = GameManager.shared.allMediumDonutsTextures[rand]
        self.color = .clear
        self.size = SpriteSize.donutMid
        
        self.position = spawnPosition
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutMid.width/2)
        
        reflectParameter = DonutConstants.Reflect.medium
        
        self.position.x += self.type == .mediumLeft ? -SpriteSize.donutMid.width/2 : SpriteSize.donutMid.width/2
        self.currForce.y = DonutConstants.startingForce.medium
        self.xParameter = self.type == .mediumLeft ? -DonutConstants.XMovement.medium : DonutConstants.XMovement.medium
        
        self.gameScene?.addChild(self)
    }
    
    func smallDonutSetup(_ spawnPosition: CGPoint) {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
        self.texture = GameManager.shared.allSmallDonutsTextures[rand]
        self.color = .clear
        self.size = SpriteSize.donutSmall
        
        self.position = spawnPosition
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutSmall.width/2)
        
        reflectParameter = DonutConstants.Reflect.small
        
        self.position.x += self.type == .smallLeft ? -SpriteSize.donutSmall.width/2 : SpriteSize.donutSmall.width/2
        self.currForce.y = DonutConstants.startingForce.small
        self.xParameter = self.type == .smallLeft ? -DonutConstants.XMovement.small : DonutConstants.XMovement.small
        
        self.gameScene?.addChild(self)
        
        self.run(SKAction.sequence([pulseWhite, pulseWhite, pulseWhite]))
    }
    
    func randomPositionSpawn() -> CGPoint {
        //random punto sull'x da cui spawnare
        let randomX = CGFloat(arc4random_uniform(UInt32((gameScene?.frame.width)!)))
        //randomizzo la direzione da cui inizierà a rimbalzare una volta spawnata
        let z: CGFloat = arc4random_uniform(2) == 1 ? -1 : 1
        xParameter = xParameter! * z
        //ritorno posizione random al di fuori dello schermo
        return CGPoint(x: randomX, y: (gameScene?.frame.height)! + hitBox!.r)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard let selfBox = self.hitBox else {return}
        let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: GameManager.shared.gravity.y)
        var positionAsVector = Vector2(x: position.x, y: position.y)
        if position.x < selfBox.r {
            xParameter = abs(xParameter!)
        } else if position.x > ((gameScene?.frame.width)! - selfBox.r) {
            xParameter = -(abs(xParameter!))
        }
        if self.xParameter! <= 0 {self.zRotation += CGFloat(DonutConstants.zRotation)} else {self.zRotation -= CGFloat(DonutConstants.zRotation)}
        
        currForce.y += gravityVector.y * velocity * CGFloat(deltaTime)
        positionAsVector.y += currForce.y * velocity * CGFloat(deltaTime)
        positionAsVector.x = positionAsVector.x + (xParameter! * velocity * CGFloat(deltaTime))

        if positionAsVector.y <= GameManager.shared.groundY + (hitBox?.r)! {
            currForce.y = reflectParameter!
            positionAsVector.y = GameManager.shared.groundY + (hitBox?.r)!
            if self.type == .smallLeft || self.type == .smallRight {
                if self.counter < 2 {counter += 1} else {
                    self.counter = 0
                    hitBox = nil
                    self.zRotation = 0
                    if debug {debugHitBox?.removeFromParent()}
                    self.run(SKAction.sequence([DestroyDonutsActions.pinkDonuts, DestroyDonutsActions.removeFromParentAction(donut: self)]))
                }
            }
        }
        
        updateHitBox()
        position = CGPoint(x: positionAsVector.x, y: positionAsVector.y)
        
    }
    
    func hit () {
        if debug {debugHitBox?.removeFromParent()}
        
        self.removeFromParent()
        let index = GameManager.shared.spawnedDonuts.index(of: self)
        
        hitBox = nil
        
        GameManager.shared.availableDonuts.append(GameManager.shared.spawnedDonuts.remove(at: index!))

        var type1: DonutType?
        var type2: DonutType?
        //Behaviours of hits
        switch self.type! {
        case .big:
            
            type1 = .mediumLeft
            type2 = .mediumRight
            
        case .mediumRight:
            
            type1 = .smallLeft
            type2 = .smallRight
            
            
            
        case .mediumLeft:
            
            type1 = .smallLeft
            type2 = .smallRight
            
        case .smallLeft:
            
            //HUD.shared.score = 5
            return
        
        case .smallRight:
            
            //HUD.shared.score = 5
            return

        }
        
        let donut1 = GameManager.shared.getDonut()
        let donut2 = GameManager.shared.getDonut()
        
        donut1.setup(type1!, gameScene: self.gameScene!, spawnPosition: self.position)
        donut2.setup(type2!, gameScene: self.gameScene!, spawnPosition: self.position)
       
//        DEBUG
      
    }
    
    
    
    func updateHitBox () {
        guard let _ = hitBox else{return}
        hitBox!.x = position.x
        hitBox!.y = position.y
        
        if debug {
            debugHitBox!.position.x = position.x
            debugHitBox!.position.y = position.y
        }
    }
    
    
}
