//
//  Constants.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

let sceneSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 16 * 9)
var groundY: CGFloat = sceneSize.height / 10.417

enum PhysicsMask {
  static let player: UInt32 = 0x1 << 1    // 2
  static let bullet: UInt32 = 0x1 << 2    // 4
  static let enemy: UInt32 = 0x1 << 3     // 8
  static let mushroom: UInt32 = 0x1 << 4  // 16
  static let world: UInt32 = 0x1 << 5     // 32
}

enum AnimationSpeeds {
    static let bodyMaxSpeed: CGFloat = 0.045
    static let legsMaxSpeed: CGFloat = 0.07
    static let bodyMinSpeedScale: CGFloat = 0.64
    static let legsMinSpeedScale: CGFloat = 0.7
    static let deathAnimationWaitTime: TimeInterval = 0.75
}

enum Z {
    static let background: CGFloat = -1.0
    static let player: CGFloat = 10.0
    static let HUD: CGFloat = 100.0
    static let fork: CGFloat = 5.0
    static let tapisRoulant: CGFloat = 6.0
}

enum SpriteSize {
    
    static let player = CGSize(width: sceneSize.width / 10.422, height: sceneSize.height / 5.859)
    static let playerDying = CGSize(width: sceneSize.width / 10.422, height: sceneSize.height / 5.137)
    static let statusBar = CGSize(width: sceneSize.width / 5.652, height: sceneSize.height / 12.097)
    static let statusBarBackground = CGSize(width: sceneSize.width / 5.467, height: sceneSize.height / 10.714)
    static let broccoli = CGSize(width: sceneSize.width / 14.822, height: sceneSize.height / 6.25)
    static let fork = CGSize(width: sceneSize.width / 44.467, height: sceneSize.height / 0.483)
    static let tapisRoulant = CGSize(width:sceneSize.width,height:sceneSize.height / 10.416)
    static let donutBig = CGSize(width: sceneSize.width / 11.117, height: sceneSize.height / 6.25)
    static let donutMid = CGSize(width: sceneSize.width / 14.822, height: sceneSize.height / 8.333)
    static let donutSmall = CGSize(width: sceneSize.width / 27.792, height: sceneSize.height / 15.625)
    static let donutAuraBig = CGSize(width: sceneSize.width / 9.809, height: sceneSize.height / 5.515)
    static let donutAuraMid = CGSize(width: sceneSize.width / 12.585, height: sceneSize.height / 7.075)
    static let donutAuraSmall = CGSize(width: sceneSize.width / 20.844, height: sceneSize.height / 11.719)
    static let tutorialPanel = CGSize(width: sceneSize.width / 1.334, height: sceneSize.height / 1.5)
    
}

enum HitBox {
    
    static let player = CGSize(width: sceneSize.width / 35.105, height: sceneSize.height / 7.813)
    
}

enum Scores {
  static let bonus = 10
  static let malus = -10
}

enum FatTimer {
    static let maxValue: TimeInterval = 20
    static let normalThreshold: TimeInterval = FatTimer.maxValue * 3/4
    static let slimThreshold: TimeInterval = FatTimer.maxValue * 1/2
    static let xsThreshold: TimeInterval = FatTimer.maxValue * 1/4
    static let bonus: TimeInterval = FatTimer.maxValue/10
}

enum DeviceGravity {
    static let min: Double = 0.030
}

enum DonutConstants {
    //modulo di rimbalzo
    enum Reflect {
        static var big: CGFloat = 0
        static var medium: CGFloat = 0
        static var small: CGFloat = 0
    }
    
    enum MaxHeight {
        static let big: CGFloat = sceneSize.height - SpriteSize.donutBig.height / 2
        static let medium: CGFloat = sceneSize.height * 0.696 - SpriteSize.donutMid.height / 2
        static let small: CGFloat = sceneSize.height * 0.429 - SpriteSize.donutSmall.height / 2
    }
    //velocità sull'asse X
    enum XMovement {
        static let big: CGFloat = sceneSize.width / 2.779 //5
        static let medium: CGFloat = sceneSize.width / 3.176 //4
        static let small: CGFloat = sceneSize.width / 4.447//3
    }
    
    enum startingForce {
        static let medium: CGFloat = sceneSize.height / 1.136 //7
        static let small: CGFloat = sceneSize.height / 1.316 //6
    }
    
    static let zRotation = Double.pi / 60
    static let gravity = CGPoint (x: 0, y: -sceneSize.height / 0.347) //-0.4
   
    
}

enum DeathReason {
    case outOfTime
    case hit
}

enum DonutsActions {
    static func removeFromParentAction(donut: Donut) -> SKAction {
        let action = SKAction.run {
            donut.removeFromParent()
            let index = GameManager.shared.spawnedDonuts.index(of: donut)
            GameManager.shared.availableDonuts.append(GameManager.shared.spawnedDonuts.remove(at: index!))
        }
        
        return action
    }
    static let pinkDonuts = SKAction.animate(with: GameManager.shared.allSmallPinkDonutsBreakTextures, timePerFrame: 0.02)
    static let smallAuraAnim = SKAction.repeatForever(SKAction.animate(with: GameManager.shared.allSmallDonutsAuraTextures, timePerFrame: 0.05))
    static let midAuraAnim = SKAction.repeatForever(SKAction.animate(with: GameManager.shared.allMidDonutsAuraTextures, timePerFrame: 0.05))
    static let bigAuraAnim = SKAction.repeatForever(SKAction.animate(with: GameManager.shared.allBigDonutsAuraTextures, timePerFrame: 0.05))
}

