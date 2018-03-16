//
//  Broccoli.swift
//  SKW
//
//  Created by Carlo Santoro on 16/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import SpriteKit

class Broccoli: SKSpriteNode {
    
    var hitBox: Rect?
    let velocity = 60
    var broccoliTexture: [SKTexture] = []
    
    var currForce = Vector2(x:0,y:0)
    var gameScene: SKScene?
    
    init(){
        broccoliTexture = GameManager.shared.allTextures.filter { $0.description.contains("broccolo") }
        super.init(texture: broccoliTexture[0], color: .clear, size: SpriteSize.broccoli)
    }
    
    func setup(gameScene: SKScene){
        
        self.gameScene = gameScene
        let randomX = CGFloat(arc4random_uniform(UInt32(gameScene.frame.width)))
        self.position.x = randomX
        self.position.y = gameScene.frame.height + hitBox!.height/2
        hitBox = Rect(x: position.x, y: position.y , height: SpriteSize.broccoli.height, width: SpriteSize.broccoli.width)
        gameScene.addChild(self)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHitBox () {
        
        hitBox!.x = position.x
        hitBox!.y = position.y
//        debugHitBox?.position.x = hitBox!.x
//        debugHitBox?.position.y = hitBox!.y
        
    }
}
