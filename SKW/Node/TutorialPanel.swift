//
//  TutorialPanel.swift
//  SKW
//
//  Created by Antonio Sirica on 19/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialPanel: SKSpriteNode {
    
    var playerRunningTextures: [SKTexture] = [] //done
    var playerShootingTextures: [SKTexture] = [] //done
    
    var TextPlayerRunning: SKLabelNode?
    var TextPlayerShooting: SKLabelNode?
    
    var playerNodeRunning: SKSpriteNode? //done
    var playerRunningAction = SKAction() //done
    
    var playerNodeShooting: SKSpriteNode? //done
    var playerShootingAction = SKAction() //done
    
    var bigDonutNode: SKSpriteNode? //done
    var smallDonutNode: SKSpriteNode? //done
    var donutAction = SKAction() //done
    
    var auraAction = SKAction() //done
    
    var showAction = SKAction() //done
    
    let spacing = 20
    
    init() {
        super.init(texture: nil, color: .clear, size: SpriteSize.tutorialPanel)
        
        //init textures
        self.playerRunningTextures = GameManager.shared.allTextures.filter { $0.description.contains("run_fat") }
        self.playerShootingTextures.append(contentsOf: playerRunningTextures)
        self.playerShootingTextures.append(SKTexture(imageNamed: "player_throw_fork_fat.png"))
        
        //player walking
        let playerRunning = SKSpriteNode(texture: playerRunningTextures[0], color: .clear, size: SpriteSize.player)
        playerNodeRunning = playerRunning
        let actionRunning = SKAction.repeatForever(SKAction.animate(with: playerRunningTextures, timePerFrame: 0.1))
        playerRunningAction = actionRunning
        
        //player shooting
        let playerShooting = SKSpriteNode(texture: playerShootingTextures[0], color: .clear, size: SpriteSize.player)
        playerNodeShooting = playerShooting
        let actionShooting = SKAction.sequence([SKAction.animate(with: playerShootingTextures, timePerFrame: 0.1), SKAction.wait(forDuration: 0.25)])
        playerShootingAction = SKAction.repeatForever(actionShooting)
        
        //big donut
        let indexBig = Int(arc4random_uniform(UInt32(GameManager.shared.allBigDonutsTextures.count)))
        let bigDonut = SKSpriteNode(texture: GameManager.shared.allBigDonutsTextures[indexBig], color: .clear, size: SpriteSize.donutBig)
        bigDonutNode = bigDonut
        
        //small donut
        let indexSmall = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
        let smallDonut = SKSpriteNode(texture: GameManager.shared.allSmallDonutsTextures[indexSmall], color: .clear, size: SpriteSize.donutSmall)
        auraAction = DonutsActions.smallAuraAnim
        smallDonutNode = smallDonut
        
        //donut rotate
        let donutRotate = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 5))
        donutAction = donutRotate
        
        //show action
        let show = SKAction.move(to: CGPoint(x: (self.scene?.frame.width)!/2, y: (self.scene?.frame.height)!/2), duration: 0.8)
        showAction = show
        
        self.zPosition = Z.HUD
        self.position.y = (self.scene?.frame.height)!/2
        self.position.x = (self.scene?.frame.width)! + self.frame.width/2
    }
    
    func show() {
        self.run(showAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
