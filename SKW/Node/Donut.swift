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
    
    var debug = true
    var currForce = Vector2(x: 0, y: 0)
    
    var gameScene: SKScene?
    init() {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allDonutsTextures.count - 1)))
        super.init(texture: GameManager.shared.allDonutsTextures[rand], color: .clear, size: SpriteSize.donutBig)
    }
    
    func setup () {
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutBig.width/2)
        
        if debug{
            debugHitBox = SKShapeNode(circleOfRadius: hitBox!.r)
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene!.addChild(debugHitBox!)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: GameManager.shared.gravity.y)
        var positionAsVector = Vector2(x: position.x, y: position.y)
        
        positionAsVector += currForce
        currForce += gravityVector

        if positionAsVector.y <= GameManager.shared.groundY {
            print(currForce)

            var reflectVector = Vector2(x: currForce.x, y: currForce.y)
            reflectVector.reflect(vector: Vector2(x: 0.001,y: 1))
         
            currForce += reflectVector
            currForce += gravityVector

//            currForce.normalize()
            print(currForce)

        }
        position = CGPoint(x: positionAsVector.x, y: positionAsVector.y)
        updateHitBox()
        
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
