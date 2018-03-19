//
//  Donut.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import SpriteKit

class Donut: SKSpriteNode {
    
    var frameCounter = 0
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
    var bounceCounter: Int = 0
    
    //aura node
    var auraNode: SKSpriteNode?
    
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
        
        let node = SKSpriteNode.init(texture: nil, color: .clear, size: .zero)
        auraNode = node
        auraNode!.zPosition = -0.001
        addChild(auraNode!)
    }
    
    func setup (_ type: DonutType, gameScene: SKScene, spawnPosition: CGPoint? = nil) {
        auraNode?.removeAllActions()
        auraNode?.texture = nil
        
        self.gameScene = gameScene
        self.type = type
        self.color = .clear
        self.bounceCounter = 0
        
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
        self.size = SpriteSize.donutBig
        
        self.currForce.y = 0
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutBig.width/2)
        
        reflectParameter = DonutConstants.Reflect.big
        xParameter = DonutConstants.XMovement.big
        self.position = self.randomPositionSpawn()
        
        auraNode?.size = SpriteSize.donutAuraBig
        if GameManager.shared.overdoseStarted == true {
            auraNode?.run(DonutsActions.bigAuraAnim)
        }
        
        gameScene?.addChild(self)
    }
    
    func mediumDonutSetup(_ spawnPosition: CGPoint) {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allMediumDonutsTextures.count)))
        self.texture = GameManager.shared.allMediumDonutsTextures[rand]
        self.size = SpriteSize.donutMid
        
        self.position = spawnPosition
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutMid.width/2)
        
        reflectParameter = DonutConstants.Reflect.medium
        
        self.position.x += self.type == .mediumLeft ? -SpriteSize.donutMid.width/2 : SpriteSize.donutMid.width/2
        self.currForce.y = DonutConstants.startingForce.medium
        self.xParameter = self.type == .mediumLeft ? -DonutConstants.XMovement.medium : DonutConstants.XMovement.medium
        
        auraNode?.size = SpriteSize.donutAuraMid
        if GameManager.shared.overdoseStarted == true {
            auraNode?.run(DonutsActions.midAuraAnim)
        }
        
        self.gameScene?.addChild(self)
    }
    
    func smallDonutSetup(_ spawnPosition: CGPoint) {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
        self.texture = GameManager.shared.allSmallDonutsTextures[rand]
        self.size = SpriteSize.donutSmall
        
        self.position = spawnPosition
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutSmall.width/2)
        
        reflectParameter = DonutConstants.Reflect.small
        
        self.position.x += self.type == .smallLeft ? -SpriteSize.donutSmall.width/2 : SpriteSize.donutSmall.width/2
        self.currForce.y = DonutConstants.startingForce.small
        self.xParameter = self.type == .smallLeft ? -DonutConstants.XMovement.small : DonutConstants.XMovement.small
        
        auraNode?.size = SpriteSize.donutAuraSmall
        auraNode?.run(DonutsActions.smallAuraAnim)
        
        self.gameScene?.addChild(self)
    }
    
    func randomPositionSpawn() -> CGPoint {
        
        //random punto sull'x da cui spawnare
        let randomX = CGFloat(arc4random_uniform(UInt32((gameScene?.frame.width)!)))
        //randomizzo la direzione da cui inizierà a rimbalzare una volta spawnata
        let z: CGFloat = arc4random_uniform(2) == 1 ? -1 : 1
        xParameter = xParameter! * z
        //ritorno posizione random al di fuori dello schermo
        guard let donutHitbox = self.hitBox else {print("Donut.randomPositionSpawn: didn't find hitbox.\n");return CGPoint(x:randomX, y:(gameScene?.frame.height)!)}
        return CGPoint(x: randomX, y: (gameScene?.frame.height)! + donutHitbox.r)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard let donutHitBox = self.hitBox else {print("Donut.update: didn't find hitBox.\n");return}
        frameCounter+=1
        
        let gravityVector = Vector2(x: DonutConstants.gravity.x, y: DonutConstants.gravity.y)
        var positionAsVector = Vector2(x: position.x, y: position.y)
        if position.x < donutHitBox.r {
            xParameter = abs(xParameter!)
        } else if position.x > ((gameScene?.frame.width)! - donutHitBox.r) {
            xParameter = -(abs(xParameter!))
        }
        if self.xParameter! <= 0 {self.zRotation += CGFloat(DonutConstants.zRotation)} else {self.zRotation -= CGFloat(DonutConstants.zRotation)}
        
        let oldForce = currForce
        currForce.y += gravityVector.y * CGFloat(deltaTime) * velocity
        positionAsVector.y += (oldForce.y + currForce.y) * 0.5 * CGFloat(deltaTime) * velocity
        positionAsVector.x = positionAsVector.x + (xParameter!) * CGFloat(deltaTime) * velocity

        if positionAsVector.y <= DonutConstants.groundY + donutHitBox.r {
            currForce.y = reflectParameter!
            positionAsVector.y = DonutConstants.groundY + donutHitBox.r
            if self.type == .smallLeft || self.type == .smallRight {
                if self.bounceCounter < 2 {bounceCounter += 1} else {
                    hitBox = nil
                    self.zRotation = 0
                    auraNode?.removeAllActions()
                    auraNode?.texture = nil
                    if debug {debugHitBox?.removeFromParent()}
                    self.run(SKAction.sequence([DonutsActions.pinkDonuts, DonutsActions.removeFromParentAction(donut: self)]))
                }
                
            }
        }
        updateHitBox()
        position = CGPoint(x: positionAsVector.x, y: positionAsVector.y)
        print("FRAME \(frameCounter): velocita:\(currForce.y) posizione:\(position.y)")
        
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
       
    }
    
    func updateHitBox () {
        guard let _hitBox = hitBox else {print("Donut.updateHitBox: didn't find hitBox\n");return}
        _hitBox.x = position.x
        _hitBox.y = position.y
        if debug {
            guard let _debugHitBox = debugHitBox else {print("Donut.updateHitBox: didn't find debugHitBox\n"); return}
            _debugHitBox.position.x = _hitBox.x
            _debugHitBox.position.y = _hitBox.y
        }
        
    }
    
    
}
