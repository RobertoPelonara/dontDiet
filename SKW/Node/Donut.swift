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
    
    enum DonutType {
        case big
        case mediumLeft
        case mediumRight
        case small
    }
    
    var debug = false
    var currForce = Vector2(x: 0, y: 0)
    
    var gameScene: SKScene?
    
    init() {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allDonutsTextures.count)))
        super.init(texture: GameManager.shared.allDonutsTextures[rand], color: .clear, size: SpriteSize.donutBig)
    }
    
    func setup (_ type: DonutType,gameScene: SKScene) {
        
        self.gameScene = gameScene
        self.type = type
        
        if type == .big {bigDonutSetup()}
        if type == DonutType.mediumLeft || type == DonutType.mediumRight {mediumDonutSetup()}
        
        if debug{
            debugHitBox = SKShapeNode(circleOfRadius: hitBox!.r)
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene.addChild(debugHitBox!)
        }
        
        GameManager.shared.spawnedDonuts.append(self)
        
    }
    
    func bigDonutSetup() {
        self.setScale(1)
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutBig.width/2)
        
        //setto il reflect per la ciambella
        reflectParameter = DonutConstants.Reflect.big
        //setto il parametro di spostamento orizzontale
        xParameter = DonutConstants.XMovement.big
        
        self.position = self.randomPositionSpawn()
        
        gameScene?.addChild(self)
    }
    
    func mediumDonutSetup() {
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutMid.width/2)
        reflectParameter = DonutConstants.Reflect.medium
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
        
        let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: GameManager.shared.gravity.y)
        var positionAsVector = Vector2(x: position.x, y: position.y)
        if position.x < (hitBox?.r)! {xParameter = abs(xParameter!)} else if position.x > ((gameScene?.frame.width)! - (hitBox?.r)!) {xParameter = -(abs(xParameter!))}
        
        currForce.y += gravityVector.y * velocity * CGFloat(deltaTime)
        positionAsVector.y += currForce.y * velocity * CGFloat(deltaTime)
        positionAsVector.x = positionAsVector.x + (xParameter! * velocity * CGFloat(deltaTime))

        if positionAsVector.y <= GameManager.shared.groundY {
            currForce.y = reflectParameter!
            positionAsVector.y = GameManager.shared.groundY
        }
        
        position = CGPoint(x: positionAsVector.x, y: positionAsVector.y)
        updateHitBox()
        
    }
    
    func forkHit (fork: Fork) {
        
        self.removeFromParent()
        fork.removeFromParent()
        
        guard let index = GameManager.shared.spawnedDonuts.index(of: self) else {print ("no donut found in spawned!"); return}
        guard let indexFork = GameManager.shared.spawnedForks.index(of: fork) else {print ("no fork found in spawned!"); return}
        GameManager.shared.availableDonuts.append(GameManager.shared.spawnedDonuts.remove(at: index))
        GameManager.shared.availableForks.append(GameManager.shared.spawnedForks.remove(at: indexFork))
        
        if self.type == .big {
            let donut1 = GameManager.shared.getDonut()
            let donut2 = GameManager.shared.getDonut()
            
            donut1.gameScene = self.gameScene
            donut2.gameScene = self.gameScene
            
            donut1.position = self.position
            donut2.position = self.position
            
            donut1.position.x -= SpriteSize.donutMid.width/2
            donut2.position.x += SpriteSize.donutMid.width/2
            
            donut1.currForce.y = DonutConstants.startingForce.medium
            donut2.currForce.y = DonutConstants.startingForce.medium
            
            donut1.xParameter = -DonutConstants.XMovement.medium
            donut2.xParameter = DonutConstants.XMovement.medium
            
            donut1.setScale(DonutConstants.scale.medium)
            donut2.setScale(DonutConstants.scale.medium)
            
            donut1.setup(.medium)
            donut2.setup(.medium)
            
            gameScene?.addChild(donut1)
            gameScene?.addChild(donut2)
        }
        
        if debug {debugHitBox?.removeFromParent()}
        if fork.debug {fork.debugHitBox?.removeFromParent()}
    }
    
    func updateHitBox () {
        hitBox!.x = position.x
        hitBox!.y = position.y
        
        if debug {
            debugHitBox!.position.x = hitBox!.x
            debugHitBox!.position.y = hitBox!.y
        }
    }
}
