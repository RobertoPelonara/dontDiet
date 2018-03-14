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
        self.position.y -= 100
        hitBox =  Rect(x: position.x, y: position.y, height: SpriteSize.fork.height, width: 10)
        
        if debug {
            debugHitBox = SKSpriteNode(color: UIColor.black, size: CGSize(width: SpriteSize.fork.width, height: SpriteSize.fork.height))
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene!.addChild(debugHitBox!)
        }
        
    }
    func update() {
        
    }
    
    func checkCollision () {
        
    }
    
}
