//
//  Broccoli.swift
//  SKW
//
//  Created by Carlo Santoro on 16/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import SpriteKit

class Broccoli: SKSpriteNode {
    
    var hitBox: Circle?
    let velocity:CGFloat = 60
    var broccoliTexture: [SKTexture] = []

    var currForce = Vector2(x:0,y:0)
    var gameScene: SKScene?
    var debugHitBox: SKShapeNode?
    
    
    private var debug = false
    
    init(){
        
        broccoliTexture = GameManager.shared.allTextures.filter { $0.description.contains("broccolo") }
        super.init(texture: broccoliTexture[0], color: .clear, size: SpriteSize.broccoli)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        
    }
    
    func setup(gameScene: SKScene){
        
        self.gameScene = gameScene
        self.currForce.y = 0
        
        let randomX = CGFloat(arc4random_uniform(UInt32(gameScene.frame.width)))
        self.position.x = randomX
        
        hitBox = Circle(x: position.x, y: position.y, radius:15.5)
        self.position.y = gameScene.frame.height + self.size.height/2
        
        if debug{
        
            debugHitBox = SKShapeNode(circleOfRadius: hitBox!.r)
            debugHitBox?.position = position
            debugHitBox?.zPosition = Z.HUD
            gameScene.addChild(debugHitBox!)
        }
        
        gameScene.addChild(self)
        
        GameManager.shared.spawnedBroccoli.append(self)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime:TimeInterval){
        
        updateMovement(deltaTime: deltaTime)
        updateHitBox()
    
    }
    
    func updateMovement(deltaTime: TimeInterval) {
        
//        let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: GameManager.shared.gravity.y)
         let gravityVector = Vector2(x: GameManager.shared.gravity.x, y: -0.2)
        var positionAsVector = Vector2(x: position.x, y: position.y)

        currForce.y += gravityVector.y * velocity * CGFloat(deltaTime)
        positionAsVector.y += currForce.y * velocity * CGFloat(deltaTime)
        
        if positionAsVector.y <= GameManager.shared.groundY + (hitBox?.r)! {
            if debug {debugHitBox?.removeFromParent()}
            self.removeFromParent()
            
            let index = GameManager.shared.spawnedBroccoli.index(of: self)
            hitBox = nil
            GameManager.shared.availableBroccoli.append(GameManager.shared.spawnedBroccoli.remove(at: index!))
            
        }
        
        position = CGPoint(x: positionAsVector.x, y: positionAsVector.y)
        
    }
    
    func updateHitBox () {
        guard let _hitBox = hitBox else {print("Broccoli.updateHitBox: didn't find hitBox\n");return}
        _hitBox.x = position.x
        _hitBox.y = position.y
        if debug {
            guard let _debugHitBox = debugHitBox else {print("Broccoli.updateHitBox: didn't find debugHitBox\n"); return}
            _debugHitBox.position.x = _hitBox.x
            _debugHitBox.position.y = _hitBox.y
        }
        
    }
    
    func hit(){
        
        self.removeFromParent()
        guard let index = GameManager.shared.spawnedBroccoli.index(of: self) else{print("Broccoli.hit: this broccoli was already removed from 'spawnedBroccoli' array");return}
        
        hitBox = nil
        if debug {
            self.debugHitBox?.removeFromParent()
        }
        GameManager.shared.availableBroccoli.append(GameManager.shared.spawnedBroccoli.remove(at: index))
        

    }
}
