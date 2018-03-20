//
//  Constants.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

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
    
    static let playerHitBox = CGSize(width: 19, height: 48)
    static let player = CGSize(width: 64, height: 64)
    static let playerDying = CGSize(width: 64, height: 73)
    static let enemy = CGSize(width: 30, height: 30)
    static let bullet = CGSize(width: 10, height: 10)
    static let mushroom = CGSize(width: 20, height: 20)
    static let button = CGSize(width: 50, height: 50)
    static let statusBar = CGSize(width: 118, height: 31)
    static let statusBarBackground = CGSize(width: 122, height: 35)
    static let broccoli = CGSize(width: 45, height: 60)
    static let fork = CGSize(width: 15, height: 777)
    static let tapisRoulant = CGSize(width:667,height:36)
    static let donutBig = CGSize(width: 60, height: 60)
    static let donutMid = CGSize(width: 45, height: 45)
    static let donutSmall = CGSize(width: 24, height: 24)
    static let donutAuraBig = CGSize(width: 68, height: 68)
    static let donutAuraMid = CGSize(width: 53, height: 53)
    static let donutAuraSmall = CGSize(width: 32, height: 32)
    static let tutorialPanel = CGSize(width: 500, height: 250)
    
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
        static let big: CGFloat = UIScreen.main.bounds.height - SpriteSize.donutBig.height / 2
        static let medium: CGFloat = UIScreen.main.bounds.height * 0.696 - SpriteSize.donutMid.height / 2
        static let small: CGFloat = UIScreen.main.bounds.height * 0.429 - SpriteSize.donutSmall.height / 2
    }
    //velocità sull'asse X
    enum XMovement {
        static let big: CGFloat = 4 //5
        static let medium: CGFloat = 3.5 //4
        static let small: CGFloat = 2.5 //3
    }
    
    enum startingForce {
        static let medium: CGFloat = 5.5 //7
        static let small: CGFloat = 4.75 //6
    }
    
    static let zRotation = Double.pi / 60
    static let gravity = CGPoint (x: 0, y: -0.3) //-0.4
    static var groundY: CGFloat = 36
    
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

