
//
//  InfoPanel.swift
//  SKW
//
//  Created by Antonio Sirica on 19/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import Foundation
import SpriteKit

class InfoPanel: SKSpriteNode {
    var currentSceneFrame: CGRect
    
    //TUTORIAL
    var playerRunningTextures: [SKTexture] = []
    var playerShootingTextures: [SKTexture] = []
    var playerLegL: [SKTexture] = []
    var playerLegR: [SKTexture] = []
    
    var playerRunningLabel = SKLabelNode(fontNamed:"Unipix")
    var playerShootingLabel = SKLabelNode(fontNamed:"Unipix")
    var bigDonutLabel = SKLabelNode(fontNamed:"Unipix")
    var smallDonutLabel = SKLabelNode(fontNamed:"Unipix")
    
    var playerNodeRunning: SKSpriteNode?
    var playerNodeShooting: SKSpriteNode?
    
    var bigDonutNode: SKSpriteNode?
    var smallDonutNode: SKSpriteNode?
    
    var auraNode: SKSpriteNode?
    
    var showAction = SKAction()
    
    let spacing: CGFloat = 50
    let labelsSpacing: CGFloat = 75
    let fontSize: CGFloat = 30
    
    //GAME OVER
    
    init(sceneSize: CGRect ) {
        self.currentSceneFrame = sceneSize
        
        //show action
        let show = SKAction.move(to: CGPoint(x: (currentSceneFrame.width)/2, y: (currentSceneFrame.height)/2), duration: 0.60)
        showAction = show
        
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "infoPanel")), color: .clear, size: SpriteSize.tutorialPanel)
        
        //position
        self.zPosition = Z.HUD
        self.position.y = sceneSize.height/2
        self.position.x = (sceneSize.width) + self.frame.width/2
    }
    
    func setupTutorial() {
        //clean node
        removeAllChildren()
        
        //lables
        playerShootingLabel.text = "TAP\nTO SHOOT"
        playerShootingLabel.numberOfLines = 2
        playerShootingLabel.fontColor = SKColor.white
        playerShootingLabel.fontSize = fontSize
//        playerShootingLabel.horizontalAlignmentMode = .left
        
        playerRunningLabel.text = "TILT\nTO MOVE"
        playerRunningLabel.numberOfLines = 2
        playerRunningLabel.fontColor = SKColor.white
        playerRunningLabel.fontSize = fontSize
//        playerRunningLabel.horizontalAlignmentMode = .left
        
        bigDonutLabel.text = "AVOID\nBIG ONES"
        bigDonutLabel.numberOfLines = 2
        bigDonutLabel.fontColor = SKColor.white
        bigDonutLabel.fontSize = fontSize
//        bigDonutLabel.horizontalAlignmentMode = .left
        
        smallDonutLabel.text = "EAT\nTO NOT DIET"
        smallDonutLabel.numberOfLines = 2
        smallDonutLabel.fontColor = SKColor.white
        smallDonutLabel.fontSize = fontSize
//        smallDonutLabel.horizontalAlignmentMode = .left
        
        //textures
        self.playerRunningTextures = GameManager.shared.allTextures.filter { $0.description.contains("run_fat") }
        self.playerShootingTextures.append(contentsOf: playerRunningTextures)
        self.playerShootingTextures.append(SKTexture(imageNamed: "player_throw_fork_fat.png"))
        self.playerLegL = GameManager.shared.allTextures.filter { $0.description.contains("legL") }
        self.playerLegR = GameManager.shared.allTextures.filter { $0.description.contains("legR") }
        
        //player running
        let playerRunning = SKSpriteNode(texture: playerRunningTextures[0], color: .clear, size: SpriteSize.player)
        playerNodeRunning = playerRunning
        let actionRunningIdle = SKAction.repeatForever(SKAction.animate(with: playerRunningTextures, timePerFrame: 0.1))
        let actionRunningMove = SKAction.repeatForever(SKAction.sequence([SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 0.75), SKAction.move(by: CGVector(dx: +20, dy: 0), duration: 0.75)]))
        playerNodeRunning?.setScale(0.75)
        playerNodeRunning?.run(actionRunningIdle)
        playerNodeRunning?.run(actionRunningMove)
        
        //player shooting
        let playerShooting = SKSpriteNode(texture: playerShootingTextures[0], color: .clear, size: SpriteSize.player)
        playerNodeShooting = playerShooting
        let actionShooting = SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: playerShootingTextures, timePerFrame: 0.1), SKAction.wait(forDuration: 0.25)]))
        playerNodeShooting?.setScale(0.75)
        playerNodeShooting?.run(actionShooting)
        
        //legs nodes
        let legRNode = SKSpriteNode(texture: playerLegR[0], size: SpriteSize.player)
        let legLNode = SKSpriteNode(texture: playerLegL[0], size: SpriteSize.player)
        legRNode.zPosition = self.zPosition + 0.01
        legLNode.zPosition = self.zPosition - 0.01
        legRNode.position = CGPoint(x: 8, y: -12)
        legLNode.position = CGPoint(x: 8, y: -12)
        let animationL = SKAction.animate(with: playerLegL, timePerFrame: 0.07)
        let animationR = SKAction.animate(with: playerLegR, timePerFrame: 0.07)
        legRNode.run(SKAction.repeatForever(animationR), withKey: "runAnim")
        legLNode.run(SKAction.repeatForever(animationL), withKey: "runAnim")
        legLNode.setScale(1.3)
        legRNode.setScale(1.3)
        
        let legRNode2: SKSpriteNode = legRNode.copy() as! SKSpriteNode
        let legLNode2: SKSpriteNode = legLNode.copy() as! SKSpriteNode
        
        playerNodeRunning?.addChild(legRNode)
        playerNodeRunning?.addChild(legLNode)
        
        playerNodeShooting?.addChild(legRNode2)
        playerNodeShooting?.addChild(legLNode2)
        
        //big donut
        let indexBig = Int(arc4random_uniform(UInt32(GameManager.shared.allBigDonutsTextures.count)))
        let bigDonut = SKSpriteNode(texture: GameManager.shared.allBigDonutsTextures[indexBig], color: .clear, size: SpriteSize.donutBig)
        bigDonutNode = bigDonut
        
        //small donut
        let indexSmall = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
        let smallDonut = SKSpriteNode(texture: GameManager.shared.allSmallDonutsTextures[indexSmall], color: .clear, size: SpriteSize.donutSmall)
        smallDonutNode = smallDonut
        
        let node = SKSpriteNode.init(texture: nil, color: .clear, size: .zero)
        auraNode = node
        auraNode!.size = SpriteSize.donutAuraSmall
        auraNode!.run(DonutsActions.smallAuraAnim)
        
        smallDonutNode?.addChild(auraNode!)
        
        //donut actions
        let donutRotate = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 5))
        
        let smallDonutChangeColor = SKAction.run {
            let index = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
            let textureAction = SKAction.setTexture(GameManager.shared.allSmallDonutsTextures[index])
            self.smallDonutNode?.run(textureAction)
        }
        let smallDonutRandomColor = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), smallDonutChangeColor]))
        
        let bigDonutChangeColor = SKAction.run {
            let index = Int(arc4random_uniform(UInt32(GameManager.shared.allBigDonutsTextures.count)))
            let textureAction = SKAction.setTexture(GameManager.shared.allBigDonutsTextures[index])
            self.bigDonutNode?.run(textureAction)
        }
        let bigDonutRandomColor = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), bigDonutChangeColor]))
        
        bigDonutNode?.run(donutRotate)
        bigDonutNode?.run(bigDonutRandomColor)
        
        smallDonutNode?.run(donutRotate)
        smallDonutNode?.run(smallDonutRandomColor)
        
        //placing players
        playerNodeRunning?.position.x = -SpriteSize.tutorialPanel.width/2 + spacing + (playerNodeRunning?.frame.width)!/2 + 10
        playerNodeRunning?.position.y = SpriteSize.tutorialPanel.height/2 - spacing - (playerNodeRunning?.frame.height)!/2
        
        playerNodeShooting?.position.x = (playerNodeRunning?.position.x)! - 10
        playerNodeShooting?.position.y = (playerNodeRunning?.position.y)! * -1
        
        self.addChild(playerNodeRunning!)
        self.addChild(playerNodeShooting!)
        
        //placing donuts
        bigDonutNode?.position.x = (bigDonutNode?.frame.width)!/2
        bigDonutNode?.position.y = (playerNodeRunning?.position.y)! - 5
        
        smallDonutNode?.position.x = (bigDonutNode?.position.x)!
        smallDonutNode?.position.y = (playerNodeShooting?.position.y)! - 5
        
        self.addChild(bigDonutNode!)
        self.addChild(smallDonutNode!)
        
        //placing labels
        playerShootingLabel.position.x = (playerNodeShooting?.position.x)! + (playerNodeShooting?.frame.width)!/2 + labelsSpacing
        playerShootingLabel.position.y = (smallDonutNode?.position.y)! - playerShootingLabel.frame.height/2
        self.addChild(playerShootingLabel)
        
        playerRunningLabel.position.x = playerShootingLabel.position.x
        playerRunningLabel.position.y = (bigDonutNode?.position.y)! - playerRunningLabel.frame.height/2
        self.addChild(playerRunningLabel)
        
        bigDonutLabel.position.x = (bigDonutNode?.position.x)! + (bigDonutNode?.frame.width)!/2 + labelsSpacing
        bigDonutLabel.position.y = playerRunningLabel.position.y
        self.addChild(bigDonutLabel)
        
        smallDonutLabel.position.x = bigDonutLabel.position.x
        smallDonutLabel.position.y = playerShootingLabel.position.y
        self.addChild(smallDonutLabel)
        
    }
    
    func show() {
        self.run(showAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
