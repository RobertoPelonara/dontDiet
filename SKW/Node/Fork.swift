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
    
    func setup(playerPosition position:CGPoint, gameScene: SKScene){

        self.gameScene = gameScene
        
        self.position = position
        self.zPosition = Z.fork
        //self.position.y -= 200
        self.position.y -= SpriteSize.fork.height/2 - SpriteSize.player.height/2
        hitBox =  Rect(x: position.x, y: position.y, height: SpriteSize.fork.height, width: 10)
        
        if debug {
            debugHitBox = SKSpriteNode(color: UIColor.white, size: CGSize(width: 8, height: SpriteSize.fork.height))
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene.addChild(debugHitBox!)
        }

        GameManager.shared.spawnedForks.append(self)
        gameScene.addChild(self)
        
    }
    func update(deltaTime:TimeInterval) {
        
        updateMovement(deltaTime: deltaTime)
        updateHitBox()
        checkCollisionWithDonuts()
        checkCollisionWithBroccoli()
        
    }
    func checkCollisionWithBroccoli() {
        for broccoli in GameManager.shared.spawnedBroccoli {
            guard let broccoliHitBox = broccoli.hitBox,let forkHitBox = self.hitBox else {print("Fork.checkCollision: didn't find one of the two hitbox in a broccoli-collision\n");return}
            
            if rectInCircle(rect: forkHitBox, circle: broccoliHitBox){
                broccoli.hit()
                destroyThisFork()
            }
        }
    }
    func checkCollisionWithDonuts () {
        
        //Check collision with donuts
        for donut in GameManager.shared.spawnedDonuts {
            guard let donutHitBox = donut.hitBox, let forkHitBox = self.hitBox else { print ("Fork.checkCollision: didn't find one of the two hitbox in a donut-collision\n"); return}
            if rectInCircle(rect: forkHitBox, circle: donutHitBox){
                donut.hit()
                destroyThisFork()
            }
        }
    }
    
    func destroyThisFork() {
        self.removeFromParent()
        
        guard let indexFork = GameManager.shared.spawnedForks.index(of: self) else {print("Fork.destroyThisFork: this fork was already destroyed.\n") ;return}
        
        GameManager.shared.availableForks.append(GameManager.shared.spawnedForks.remove(at: indexFork))
        if self.debug {self.debugHitBox?.removeFromParent()}

    }
    
    func updateMovement(deltaTime:TimeInterval){
        
        if self.position.y + SpriteSize.fork.height/2 >= (gameScene?.frame.height)! {
            self.removeFromParent()
            guard let index = GameManager.shared.spawnedForks.index(of: self) else {print("Fork.updateMovement: this fork wasn't in 'spawnedForks' array.\n");return}
            GameManager.shared.availableForks.append(GameManager.shared.spawnedForks.remove(at: index))
            
            if debug {debugHitBox?.removeFromParent()}
          
        } else {
            
            let deltaMove = velocity * CGFloat(deltaTime)
            self.position.y += deltaMove
            
        }
    }
    
    func updateHitBox () {
        guard let _ = hitBox else {print("Fork.updateHitBox: didn't find hitBox\n");return}
        hitBox!.x = position.x
        hitBox!.y = position.y
        if debug {
            guard let _ = debugHitBox else {print("Fork.updateHitBox: didn't find debugHitBox\n"); return}
            debugHitBox!.position.x = hitBox!.x
            debugHitBox!.position.y = hitBox!.y
        }
        
    }
    
}
