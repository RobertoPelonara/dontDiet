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
//    var isInGame = false
    var indexInArray: Int?
    var debug = false
    
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
//        self.isInGame = true
        
        
        
        self.position = position
        self.zPosition = Z.fork
        //self.position.y -= 200
        self.position.y -= SpriteSize.fork.height/2 - SpriteSize.player.height/2
        hitBox =  Rect(x: position.x, y: position.y, height: SpriteSize.fork.height, width: 10)
        
        if debug {
            debugHitBox = SKSpriteNode(color: UIColor.white, size: CGSize(width: 8, height: SpriteSize.fork.height))
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene!.addChild(debugHitBox!)
        }

        GameManager.shared.spawnedForks.append(self)
        
    }
    func update(deltaTime:TimeInterval) {
        
        updateMovement(deltaTime: deltaTime)
        updateHitBox()
        checkCollision()
    }
    
    func checkCollision () {
        
        for donut in GameManager.shared.spawnedDonuts {
            if rectInCircle(rect: self.hitBox!, circle: donut.hitBox!){
                donut.forkHit(fork: self)
                
            }
        }
        
    }
    
    func updateMovement(deltaTime:TimeInterval){
        
        if self.position.y + SpriteSize.fork.height/2 >= (gameScene?.frame.height)! {
            self.removeFromParent()
            let index = GameManager.shared.spawnedForks.index(of: self)
            GameManager.shared.availableForks.append(GameManager.shared.spawnedForks.remove(at: index!))
            
            
            if debug {debugHitBox?.removeFromParent()}
          
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
