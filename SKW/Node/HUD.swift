//
//  HUD.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    
    let scoreLabel = SKLabelNode(fontNamed:"Courier")
    
    let statusBar = SKSpriteNode()
    let statusBarBackground = SKSpriteNode()
    let cropNode = SKCropNode()
    let maskNode = SKSpriteNode(color: .black, size: CGSize(width: SpriteSize.statusBar.width, height: SpriteSize.statusBar.height))
    
    var score: Int {
        get {
            return GameManager.shared.score
        }
        set {
            scoreLabel.text = "Score: \(GameManager.shared.score)"
        }
    }
    
    var timer: [TimeInterval] {
        get {
            return [GameManager.shared.timer]
        }
        set {
            cropNode.childNode(withName: "bar")?.position.x -= (SpriteSize.statusBar.width * CGFloat(newValue[0])) / CGFloat(FatTimer.maxValue)
            cropNode.position.x += (SpriteSize.statusBar.width * CGFloat(newValue[0])) / CGFloat(FatTimer.maxValue)
        }
    }
    
    override init() {
        
        super.init()
        
        self.name = "HUD"
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.zPosition = Z.HUD
        
        statusBar.texture = SKTexture.init(imageNamed: "candy_cane.png")
        statusBar.color = .clear
        statusBar.size = SpriteSize.statusBar
        statusBar.zPosition = Z.HUD
        statusBar.name = "bar"
        
        statusBarBackground.texture = SKTexture.init(imageNamed: "white_gradient.png")
        statusBarBackground.color = .clear
        statusBarBackground.zPosition = Z.HUD - 10
        
        cropNode.zPosition = Z.HUD
    }
    
    func setup(size: CGSize) {
        
        let spacing: CGFloat = 10
        
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: spacing, y: size.height - scoreLabel.frame.height - spacing)
        addChild(scoreLabel)
        
        cropNode.position = CGPoint(x: size.width - (spacing * 2) - SpriteSize.statusBar.width/2, y: size.height - SpriteSize.statusBar.height/2 - (spacing * 2))
        cropNode.addChild(statusBar)
        cropNode.maskNode = maskNode
        addChild(cropNode)
        
        statusBar.position = .zero
        
        statusBarBackground.size = CGSize(width: SpriteSize.statusBar.width * 2, height: SpriteSize.statusBar.height * 7)
        statusBarBackground.position = cropNode.position
        addChild(statusBarBackground)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
