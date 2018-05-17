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
    var isShown = false
    var isEndPanel = false
    
    
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
    
    let spacing: CGFloat = 13.34
    let labelsSpacing: CGFloat = 8.89
    let fontSize: CGFloat = 12.5
    
    //GAME OVER
    var titleLabel = SKLabelNode(fontNamed: "Unipix")
    var scoreLabel = SKLabelNode(fontNamed: "Unipix")
    var recordLabel = SKLabelNode(fontNamed: "Unipix")
    var timerLabel = SKLabelNode(fontNamed: "Unipix")
    var tapToReturn = SKLabelNode(fontNamed: "Unipix")
    var titleShadow = SKLabelNode(fontNamed: "Unipix")
    var buttonHome = SKSpriteNode(imageNamed: "buttons0")
    var buttonRestart = SKSpriteNode(imageNamed: "buttons1")
    
    
    //FADE NERO
    var fade = SKShapeNode(rectOf: (GameManager.shared.gameViewController?.view.frame.size)!)
    
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
        
        //TUTORIAL
        //self position
        self.zPosition = Z.HUD
        self.position.y = sceneFrame.height/2
        self.position.x = (sceneFrame.width) + self.frame.width/2
        
        //lables
        playerShootingLabel.text = "TAP\nTO SHOOT"
        playerShootingLabel.numberOfLines = 2
        playerShootingLabel.fontColor = SKColor.white
        playerShootingLabel.fontSize = sceneSize.height /  fontSize
        //        playerShootingLabel.horizontalAlignmentMode = .left
        
        playerRunningLabel.text = "TILT\nTO MOVE"
        playerRunningLabel.numberOfLines = 2
        playerRunningLabel.fontColor = SKColor.white
        playerRunningLabel.fontSize = sceneSize.height / fontSize
        //        playerRunningLabel.horizontalAlignmentMode = .left
        
        bigDonutLabel.text = "AVOID\nBIG ONES"
        bigDonutLabel.numberOfLines = 2
        bigDonutLabel.fontColor = SKColor.white
        bigDonutLabel.fontSize = sceneSize.height / fontSize
        //        bigDonutLabel.horizontalAlignmentMode = .left
        
        smallDonutLabel.text = "EAT\nTO NOT DIET"
        smallDonutLabel.numberOfLines = 2
        smallDonutLabel.fontColor = SKColor.white
        smallDonutLabel.fontSize = sceneSize.height / fontSize
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
        
        let legY = (sceneSize.height * -12) / 375
        let legX = (sceneSize.width * 8) / 667

        legRNode!.position = CGPoint(x: legX, y: legY)
        legLNode!.position = CGPoint(x: legX, y: legY)
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
        let charSpacing = sceneSize.width * 10 / 667
            
        playerNodeRunning?.position.x = -SpriteSize.tutorialPanel.width/2 + (sceneSize.width / spacing)
        playerNodeRunning?.position.x += (playerNodeRunning?.frame.width)!/2 + charSpacing
        playerNodeRunning?.position.y = SpriteSize.tutorialPanel.height/2 - (sceneSize.width / spacing) - (playerNodeRunning?.frame.height)!/2
        
        playerNodeShooting?.position.x = (playerNodeRunning?.position.x)! - charSpacing
        playerNodeShooting?.position.y = (playerNodeRunning?.position.y)! * -1
        
        //donuts positions
        bigDonutNode?.position.x = (bigDonutNode?.frame.width)!/2
        bigDonutNode?.position.y = (playerNodeRunning?.position.y)! - 5
        
        smallDonutNode?.position.x = (bigDonutNode?.position.x)!
        smallDonutNode?.position.y = (playerNodeShooting?.position.y)! - 5
        
        //labels positions
        playerShootingLabel.position.x = (playerNodeShooting?.position.x)! + (playerNodeShooting?.frame.width)!/2 + (sceneSize.width / labelsSpacing)
        playerShootingLabel.position.y = (smallDonutNode?.position.y)! - playerShootingLabel.frame.height/2
        
        playerRunningLabel.position.x = playerShootingLabel.position.x
        playerRunningLabel.position.y = (bigDonutNode?.position.y)! - playerRunningLabel.frame.height/2
        
        bigDonutLabel.position.x = (bigDonutNode?.position.x)! + (bigDonutNode?.frame.width)!/2 + (sceneSize.width / labelsSpacing)
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
        
        //GAMEOVER LABELS
        
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: sceneSize.width / 9.52)
        
        scoreLabel.fontSize = sceneSize.width / 18.52
        scoreLabel.fontColor = .white
        scoreLabel.text = "You gained \(GameManager.shared.score) calories"
        scoreLabel.position = CGPoint(x: titleLabel.position.x , y: titleLabel.position.y - (sceneSize.width / 11.11))
        
        recordLabel.fontSize = sceneSize.width / 23.82
        recordLabel.fontColor = .white
        recordLabel.text = "Your highest score was \((GameManager.shared.gameViewController?.highestScore)!) calories"
        recordLabel.position = CGPoint(x: scoreLabel.position.x , y: scoreLabel.position.y - (sceneSize.width / 13.34))
        
        timerLabel.fontSize = sceneSize.width / 23.82
        timerLabel.fontColor = .white
        timerLabel.text = "You fought for \(Int(GameManager.shared.totalGameTimer)) seconds against the diet"
        timerLabel.position = CGPoint(x: titleLabel.position.x , y: scoreLabel.position.y - (sceneSize.width / 22.23))
        
        tapToReturn.fontSize = sceneSize.width / 25.65
        tapToReturn.fontColor = .black
        tapToReturn.color?.withAlphaComponent(0.6)
        tapToReturn.text = "Easter Egg"
        tapToReturn.position = CGPoint(x: titleLabel.position.x , y: timerLabel.position.y - (sceneSize.width / 66.7))
        
        titleShadow.fontColor = .black
        titleShadow.position = CGPoint(x: (size.width / 2)+1, y: size.height / 1.2)
        
        buttonHome.position = CGPoint(x: 0, y: -(sceneSize.width / 6.67))
        buttonRestart.position = CGPoint(x: 0, y: -100)
        
        buttonHome.name = "buttonHome"
        buttonRestart.name = "buttonRestart"
        
        fade.fillColor = UIColor(ciColor: .black).withAlphaComponent(0.5)
        fade.zPosition = -1
    }
    
    func goToMainMenu () {
        hide()
        GameManager.shared.gameViewController?.loadScene(GameManager.shared.menuScene!, GameManager.shared.gameScene)
        GameManager.shared.gamePaused = false
        
    }
    
    func restartGame () {
        hide()
        let scene = GameScene(size: size)
        
        GameManager.shared.gameViewController?.loadScene(scene, GameManager.shared.gameScene)
        
        GameManager.shared.gameScene = scene
        GameManager.shared.gamePaused = false
        
    }
    
    func setupTutorial() {
        
        removeAllChildren()
        
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
    
    func setupEndPanel() {
        
        removeAllChildren()
        
        scoreLabel.text = "You gained \(GameManager.shared.score) calories"
        recordLabel.text = "Your highest score was \((GameManager.shared.gameViewController?.highestScore)!) calories"
        timerLabel.text = "You fought for \(Int(GameManager.shared.totalGameTimer)) seconds against the diet"
        
        //setup death reason
        titleShadow.fontSize = (GameManager.shared.deathReason == .outOfTime) ? (sceneSize.width / 8.13) : (sceneSize.width / 13.08)
        titleShadow.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
        
        titleLabel.fontSize = (GameManager.shared.deathReason == .outOfTime) ? (sceneSize.width / 11.3) : (sceneSize.width / 16.67)
        titleLabel.text = (GameManager.shared.deathReason == .outOfTime) ? "The Diet win" : "That donut was too heavy"
        
        //add nodes in panel
        addChild(titleLabel)
        addChild(scoreLabel)
        addChild(recordLabel)
        addChild(timerLabel)
        addChild(tapToReturn)
        addChild(titleShadow)
        addChild(buttonHome)
        //        addChild(buttonRestart)
        
    }
    
    func show() {
        isShown = true
        self.run(showAction)
        //addChild(fade)
        
    }
    
    func hide() {
        isShown = false
        fade.removeFromParent()
        self.run(hideAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
