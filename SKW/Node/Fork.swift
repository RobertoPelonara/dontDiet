//
//  Fork.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import SpriteKit

class Fork: SKSpriteNode {
    
    var hitBox: Rect?
    var debugHitBox: SKSpriteNode?
    var gameScene: SKScene?
    let velocity:CGFloat = 240
    private var debug = false
    
    init() {
        let forkTexture = GameManager.shared.allTextures.first { (texture) -> Bool in
            return texture.description.contains("Fork")
        }
        super.init(texture: forkTexture, color: .clear, size: SpriteSize.fork)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(playerPosition position:CGPoint){
        
        self.position = position
        self.zPosition = Z.fork
        //self.position.y -= 200
        self.position.y -= SpriteSize.fork.height/2 - SpriteSize.player.height/2
        hitBox =  Rect(x: position.x, y: position.y, height: SpriteSize.fork.height, width: 10)
        
        if debug {
            debugHitBox = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: SpriteSize.fork.height))
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene!.addChild(debugHitBox!)
        }
        
    }
    func update(deltaTime:TimeInterval, playerPosition position:CGPoint) {
//        if self.position.y <= position.y + SpriteSize.player.height/2 {
//            self.zPosition = Z.background - 1
//        } else {
//            self.zPosition = Z.sprites - 1
//        }
        updateMovement(deltaTime: deltaTime)
        
        updateHitBox()
    }
    
    func checkCollision () {
        
    }
    
    func updateMovement(deltaTime:TimeInterval){
        
        if self.position.y + SpriteSize.fork.height/2 >= (gameScene?.frame.height)! {
            self.removeFromParent()
           //RIMUOVERE QUESTA FORCHETTA DALL'ARRAY COMM CAZZ S FA?
        } else {
            
            let deltaMove = velocity * CGFloat(deltaTime)
            self.position.y += deltaMove
            
        }
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
