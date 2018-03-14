//
//  GameScene.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    // Actors
    var perna = Player()
    var hud = HUD()
    let enemies = (rows: 3, cols: 12)
    
    // Update Timer
    var lastTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    
    // Donut spawn Timer
    var lastDonutTime: TimeInterval = 0
    var timeFromLastDonut: TimeInterval = 0
    var spawnInterval: TimeInterval = 0
    
    // Special
    var donut: Donut? = nil
    var debugHitBox: SKSpriteNode?
    // Gesture
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    let triggerDistance: CGFloat = 20
    var initialTouch: CGPoint = CGPoint.zero
    
    
    
    // Before the Scene
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx:0, dy: -9.8)
        //    self.physicsBody?.restitution = 0
        //    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = Z.background
        addChild(background)
        //    debugPrint(PhysicsMask.player)
        //    debugPrint(PhysicsMask.bullet)
        //    debugPrint(PhysicsMask.player | PhysicsMask.bullet)
        // Player
        perna.gameScene = self
        
        perna.setup(view: self.view!)
        let range = SKRange(lowerLimit: 0.0 + SpriteSize.player.width / 2, upperLimit: perna.limit! - SpriteSize.player.width / 2)
        let stattFerm = [SKConstraint.positionX(range)]
        perna.constraints = stattFerm
        addChild(perna)
        
        //var prevX:CGFloat = 30
        //var increment:CGFloat = 40
        //    for i in 0...0 {
        //        var donut = Donut()
        //        donut.gameScene = self
        //        donut.setup(player: perna)
        //        prevX += increment
        //        GameManager.shared.spawnedDonuts.append(donut)
        //        addChild(donut)
        //        donut.gameScene = self
        //    }
        
        // HUD
        hud.setup(size: size)
        addChild(hud)
        
        // Start Game
        
        
        // Gestures
        
    }
    
    
    
    func touchDown(atPoint pos: CGPoint) {
        
        // Gesture Start Detect
        
        //        var prevX:CGFloat = 30
        //        let increment:CGFloat = 40
        
        //    initialTouch = pos
        //    deltaX = 0
        //    deltaY = 0
        //
        //    let touchedNode = self.atPoint(pos)
        //    if touchedNode.name == "buttonFire" {
        //      let button = touchedNode as? SKSpriteNode
        //      button?.texture = SKTexture(imageNamed: "buttonFire-pressed")
        //      return
        //    }
        
        
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        // Delta Saving
        deltaX = pos.x - initialTouch.x
        deltaY = pos.y - initialTouch.y
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
        // Gesture Trigger
        if fabs(deltaX) > triggerDistance {
            if deltaX < 0 {
                // Left Swipe
            } else {
                // Right Swipe
            }
        } else if fabs(deltaY) > triggerDistance {
            if deltaY < 0 {
                // Down Swipe
            } else {
                // Up Swipe
                //        perna.jump()
            }
        }
        
        // With childNode
        if let button = hud.childNode(withName: "buttonFire") as? SKSpriteNode {
            button.texture = SKTexture(imageNamed: "buttonFire-normal")
        }
        
        // With atPoint
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "buttonFire" {
            perna.fire()
            return
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchDown(atPoint: touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchMoved(toPoint: touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchUp(atPoint: touch.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // MARK: Render Loop
    override func update(_ currentTime: TimeInterval) {
        
        // If we don't have a last frame time value, this is the first frame, so delta time will be zero.
        if lastTime <= 0 { lastTime = currentTime }
        
        // Random spawn
        spawnEnemies(initTime: currentTime)
        
        // Update delta time
        deltaTime = currentTime - lastTime
        // debugPrint("\(deltaTime * 1000) milliseconds")
        
        // Set last frame time to current time
        lastTime = currentTime
        
        for donut in GameManager.shared.spawnedDonuts {
            donut.update(deltaTime: deltaTime)
        }
        
        perna.update(deltaTime: deltaTime)
        debugHitBox?.position.x = perna.hitBox!.x
        debugHitBox?.position.y = perna.hitBox!.y
        //    checkSimpleCollision()
        
    }
    
    func spawnEnemies(initTime: TimeInterval) {
        if spawnInterval == 0 {
            spawnInterval = TimeInterval(arc4random_uniform(101) + 300) / 100
            print(spawnInterval)
        }
        
        if lastDonutTime <= 0 { lastDonutTime = initTime; timeFromLastDonut = initTime } else {timeFromLastDonut = initTime - lastDonutTime}
        
        if timeFromLastDonut > spawnInterval {
            spawnInterval = 0
            
            let donut = Donut()
            donut.gameScene = self
            donut.setup(.big)
            GameManager.shared.spawnedDonuts.append(donut)
            addChild(donut)
            
            lastDonutTime = initTime
        }
    }
    
    // Physics Collision
    func didBegin(_ contact: SKPhysicsContact) {
        debugPrint("bodyA: \(contact.bodyA.node!.name!)")
        debugPrint("bodyB: \(contact.bodyB.node!.name!)")
        
        // Bullet vs Enemy
        if (contact.bodyA.categoryBitMask == PhysicsMask.enemy) {
            debugPrint("enemy A hit")
            //       contact.bodyA.node!.removeFromParent()
            //       contact.bodyB.node!.removeFromParent()
            
            // Bullet vs Enemy
            if (contact.bodyB.node!.name! == "bullet") {
                let enemy = contact.bodyA.node! as? Enemy
                enemy?.spawnMushroom()
                contact.bodyB.node!.removeFromParent()
                
            }
            
            // Beam vs Enemy
            //      if (contact.bodyB.node!.name! == "beam") {
            //        let enemy = contact.bodyA.node! as? Enemy
            //        enemy?.spawnMushroom()
            //      }
        } else if (contact.bodyB.categoryBitMask == PhysicsMask.enemy) {
            debugPrint("enemy B hit") // 😅
        }
        
        // Mushroom vs Player
        if (contact.bodyA.categoryBitMask == PhysicsMask.player) {
            debugPrint("player A hit")
            perna.eat(mushroom: contact.bodyB.node!)
        } else if (contact.bodyB.categoryBitMask == PhysicsMask.player) {
            debugPrint("player B hit")
        }
        
    }
    
    // Simple Collision
    func checkSimpleCollision() {
        enumerateChildNodes(withName: "enemy") { enemy, stop in
            self.enumerateChildNodes(withName: "bullet") { bullet, stop in
                if enemy.frame.intersects(bullet.frame) {
                    debugPrint("intersected!")
                    let en = enemy as? Enemy
                    en?.spawnMushroom()
                    bullet.removeFromParent()
                }
            }
        }
    }
    
    // Check EndGame
    func checkTimer() {
        
    }
    
    // Charge Special Weapon
    func chargeBeam() {
        
    }
    
}
