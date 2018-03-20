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
    
    var runningIdle = SKAction()
    var runningMove = SKAction()
    var shootingIdle = SKAction()
    var legRIdle = SKAction()
    var legLIdle = SKAction()
    
    var playerNodeRunning: SKSpriteNode?
    var playerNodeShooting: SKSpriteNode?
    
    var legRNode: SKSpriteNode?
    var legRNode2: SKSpriteNode?
    var legLNode: SKSpriteNode?
    var legLNode2: SKSpriteNode?
    
    var bigDonutNode: SKSpriteNode?
    var smallDonutNode: SKSpriteNode?
    
    var rotateAction = SKAction()
    var bigDonutColor = SKAction()
    var smallDonutColor = SKAction()
    
    var auraNode: SKSpriteNode?
    
    var showAction = SKAction()
    var hideAction = SKAction()
    
    let spacing: CGFloat = 50
    let labelsSpacing: CGFloat = 75
    let fontSize: CGFloat = 30
    
    //GAME OVER
    
    init(sceneFrame: CGRect ) {
        self.currentSceneFrame = sceneFrame
        
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "infoPanel")), color: .clear, size: SpriteSize.tutorialPanel)
        
        //show action
        let show = SKAction.move(to: CGPoint(x: (currentSceneFrame.width)/2, y: (currentSceneFrame.height)/2), duration: 0.60)
        showAction = show
        
        //hide action
        let hide = SKAction.sequence([SKAction.move(to: CGPoint(x: -(currentSceneFrame.width)/2, y: (currentSceneFrame.height)/2), duration: 0.60), SKAction.run {
            self.position.x = (sceneFrame.width) + self.frame.width/2
            }])
        hideAction = hide
        
        //self position
        self.zPosition = Z.HUD
        self.position.y = sceneFrame.height/2
        self.position.x = (sceneFrame.width) + self.frame.width/2
        
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
        runningIdle = actionRunningIdle
        runningMove = actionRunningMove
        playerNodeRunning?.setScale(0.75)
        
        //player shooting
        let playerShooting = SKSpriteNode(texture: playerShootingTextures[0], color: .clear, size: SpriteSize.player)
        playerNodeShooting = playerShooting
        let actionShooting = SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: playerShootingTextures, timePerFrame: 0.1), SKAction.wait(forDuration: 0.25)]))
        shootingIdle = actionShooting
        playerNodeShooting?.setScale(0.75)
        
        //legs nodes
        let legR = SKSpriteNode(texture: playerLegR[0], size: SpriteSize.player)
        let legL = SKSpriteNode(texture: playerLegL[0], size: SpriteSize.player)
        legRNode = legR
        legLNode = legL
        legRNode!.zPosition = self.zPosition + 0.01
        legLNode!.zPosition = self.zPosition - 0.01
        legRNode!.position = CGPoint(x: 8, y: -12)
        legLNode!.position = CGPoint(x: 8, y: -12)
        let animationL = SKAction.animate(with: playerLegL, timePerFrame: 0.07)
        let animationR = SKAction.animate(with: playerLegR, timePerFrame: 0.07)
        legLIdle = animationL
        legRIdle = animationR
        legLNode!.setScale(1.3)
        legRNode!.setScale(1.3)
        
        legRNode2 = legRNode!.copy() as? SKSpriteNode
        legLNode2 = legLNode!.copy() as? SKSpriteNode
        
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
        
        //donut actions
        let donutRotate = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 5))
        rotateAction = donutRotate
        
        let smallDonutChangeColor = SKAction.run {
            let index = Int(arc4random_uniform(UInt32(GameManager.shared.allSmallDonutsTextures.count)))
            let textureAction = SKAction.setTexture(GameManager.shared.allSmallDonutsTextures[index])
            self.smallDonutNode?.run(textureAction)
        }
        let smallDonutRandomColor = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), smallDonutChangeColor]))
        smallDonutColor = smallDonutRandomColor
        
        let bigDonutChangeColor = SKAction.run {
            let index = Int(arc4random_uniform(UInt32(GameManager.shared.allBigDonutsTextures.count)))
            let textureAction = SKAction.setTexture(GameManager.shared.allBigDonutsTextures[index])
            self.bigDonutNode?.run(textureAction)
        }
        let bigDonutRandomColor = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), bigDonutChangeColor]))
        bigDonutColor = bigDonutRandomColor
        
        //players positions
        playerNodeRunning?.position.x = -SpriteSize.tutorialPanel.width/2 + spacing + (playerNodeRunning?.frame.width)!/2 + 10
        playerNodeRunning?.position.y = SpriteSize.tutorialPanel.height/2 - spacing - (playerNodeRunning?.frame.height)!/2
        
        playerNodeShooting?.position.x = (playerNodeRunning?.position.x)! - 10
        playerNodeShooting?.position.y = (playerNodeRunning?.position.y)! * -1
        
        //donuts positions
        bigDonutNode?.position.x = (bigDonutNode?.frame.width)!/2
        bigDonutNode?.position.y = (playerNodeRunning?.position.y)! - 5
        
        smallDonutNode?.position.x = (bigDonutNode?.position.x)!
        smallDonutNode?.position.y = (playerNodeShooting?.position.y)! - 5
        
        //labels positions
        playerShootingLabel.position.x = (playerNodeShooting?.position.x)! + (playerNodeShooting?.frame.width)!/2 + labelsSpacing
        playerShootingLabel.position.y = (smallDonutNode?.position.y)! - playerShootingLabel.frame.height/2
        
        playerRunningLabel.position.x = playerShootingLabel.position.x
        playerRunningLabel.position.y = (bigDonutNode?.position.y)! - playerRunningLabel.frame.height/2
        
        bigDonutLabel.position.x = (bigDonutNode?.position.x)! + (bigDonutNode?.frame.width)!/2 + labelsSpacing
        bigDonutLabel.position.y = playerRunningLabel.position.y
        
        smallDonutLabel.position.x = bigDonutLabel.position.x
        smallDonutLabel.position.y = playerShootingLabel.position.y
        
        //run actions
        playerNodeRunning?.run(runningIdle)
        playerNodeRunning?.run(runningMove)
        
        playerNodeShooting?.run(shootingIdle)
        
        legRNode!.run(SKAction.repeatForever(legRIdle))
        legLNode!.run(SKAction.repeatForever(legLIdle))
        legRNode2!.run(SKAction.repeatForever(legRIdle))
        legLNode2!.run(SKAction.repeatForever(legLIdle))
        
        auraNode!.run(DonutsActions.smallAuraAnim)
        
        bigDonutNode?.run(rotateAction)
        bigDonutNode?.run(bigDonutColor)
        
        smallDonutNode?.run(rotateAction)
        smallDonutNode?.run(smallDonutColor)
        
        //nodes final setup
        playerNodeRunning?.addChild(legRNode!)
        playerNodeRunning?.addChild(legLNode!)
        
        playerNodeShooting?.addChild(legRNode2!)
        playerNodeShooting?.addChild(legLNode2!)
        
        smallDonutNode?.addChild(auraNode!)
        
    }
    
    func setupTutorial() {
        
        //add nodes in panel
        self.addChild(playerNodeRunning!)
        self.addChild(playerNodeShooting!)
        
        self.addChild(bigDonutNode!)
        self.addChild(smallDonutNode!)
        
        self.addChild(playerShootingLabel)
        self.addChild(playerRunningLabel)
        self.addChild(bigDonutLabel)
        self.addChild(smallDonutLabel)
    }
    
    func setupEndPanel () {
        
        removeAllChildren()
        
        
        let titleLabel = SKLabelNode(fontNamed: "Unipix")
        titleLabel.fontSize = (GameManager.shared.deathReason == .outOfTime) ? 59 : 40
        titleLabel.fontColor = .white
        titleLabel.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
        titleLabel.position = CGPoint(x: 0, y: 70)
        addChild(titleLabel)
        
//        let titleShadow = SKLabelNode(fontNamed: "Unipix")
//        titleShadow.fontSize = (GameManager.shared.deathReason == .outOfTime) ? 82 : 51
//        titleShadow.fontColor = .black
//        titleShadow.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
//        titleShadow.position = CGPoint(x: (size.width / 2)+1, y: size.height / 1.2)
//        addChild(titleShadow)
       
        
        let scoreLabel = SKLabelNode(fontNamed: "Unipix")
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .white
        scoreLabel.text = "You gained \(GameManager.shared.score) calories"
        scoreLabel.position = CGPoint(x: titleLabel.position.x , y: titleLabel.position.y - 60)
        addChild(scoreLabel)
        
        let recordLabel = SKLabelNode(fontNamed: "Unipix")
        recordLabel.fontSize = 28
        recordLabel.fontColor = .white
        recordLabel.text = "Your highest score was \((GameManager.shared.gameViewController?.highestScore)!) calories"
        recordLabel.position = CGPoint(x: scoreLabel.position.x , y: scoreLabel.position.y - 50)
        addChild(recordLabel)
        
        let timerLabel = SKLabelNode(fontNamed: "Unipix")
        timerLabel.fontSize = 28
        timerLabel.fontColor = .white
        timerLabel.text = "You fought for \(Int(GameManager.shared.totalGameTimer)) seconds against the diet"
        timerLabel.position = CGPoint(x: titleLabel.position.x , y: scoreLabel.position.y - 30)
        addChild(timerLabel)
        
        let tapToReturn = SKLabelNode(fontNamed: "Unipix")
        tapToReturn.fontSize = 26
        tapToReturn.fontColor = .black
        tapToReturn.color?.withAlphaComponent(0.7)
        tapToReturn.text = "Tap to return to Main Menu"
        tapToReturn.position = CGPoint(x: titleLabel.position.x , y: timerLabel.position.y - 10)
        addChild(tapToReturn)
        
    }
    
    func show() {
        self.run(showAction)
    }
    
    func hide() {
        self.run(hideAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
