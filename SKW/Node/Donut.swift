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
    var xParameter: CGFloat = 5
    let reflectParameter: CGFloat = 14
    
    var debug = true
    var currForce = Vector2(x: 0, y: 0)
    
    var gameScene: SKScene?
    init() {
        let rand = Int(arc4random_uniform(UInt32(GameManager.shared.allDonutsTextures.count - 1)))
        super.init(texture: GameManager.shared.allDonutsTextures[rand], color: .clear, size: SpriteSize.donutBig)
    }
    
    func setup (player: Player) {
        
        hitBox = Circle(x: position.x, y: position.y, radius: SpriteSize.donutBig.width/2)
        
        if debug{
            debugHitBox = SKShapeNode(circleOfRadius: hitBox!.r)
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene!.addChild(debugHitBox!)
            
        }
        
    }
    
    func randomSpawnPosition() {
        //random punto sull'x da cui spawnare
        let randomX = Int(arc4random_uniform(UInt32((gameScene?.frame.width)!)))
        
        //randomizzo la direzione (+/- xParameter) da cui inizierà a rimbalzare una volta spawnata
        let z: CGFloat = arc4random_uniform(2) == 1 ? -1 : 1
        xParameter = xParameter * z
        
        //applico posizione di partenza random sull'x ma al di sopra dello schermo
        self.position = CGPoint(x: CGFloat(randomX), y: (gameScene?.frame.height)! + hitBox!.r)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: GameManager.shared.gravity.y)
        var positionAsVector = Vector2(x: position.x, y: position.y)
        if position.x < (hitBox?.r)! {xParameter = abs(xParameter)} else if position.x > ((super.scene?.frame.width)! - (hitBox?.r)!) {xParameter = -(abs(xParameter))}
        
        positionAsVector += currForce
        currForce += gravityVector

        if positionAsVector.y <= GameManager.shared.groundY {currForce.y = reflectParameter}
        
        position = CGPoint(x: (positionAsVector.x + xParameter), y: positionAsVector.y)
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
