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
}

enum Z {
    static let background: CGFloat = -1.0
    static let player: CGFloat = 10.0
    static let HUD: CGFloat = 100.0
    static let fork: CGFloat = 5.0
}

enum SpriteSize {
    
    static let player = CGSize(width: 64, height: 64)
    static let enemy = CGSize(width: 30, height: 30)
    static let bullet = CGSize(width: 10, height: 10)
    static let mushroom = CGSize(width: 20, height: 20)
    static let button = CGSize(width: 50, height: 50)
    
    static let fork = CGSize(width: 15, height: 777)
    
    static let donutBig = CGSize(width: 60, height: 60)
    static let donutMid = CGSize(width: (SpriteSize.donutBig.width * DonutConstants.scale.medium), height: (SpriteSize.donutBig.height * DonutConstants.scale.medium))
    static let donutSmall = CGSize(width: (SpriteSize.donutBig.width * DonutConstants.scale.small), height: (SpriteSize.donutBig.height * DonutConstants.scale.small))
    
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
}

enum DeviceGravity {
    static let min: Double = 0.030
}

enum DonutConstants {
    //modulo di rimbalzo
    enum Reflect {
        static let big: CGFloat = 15.2
        static let medium: CGFloat = 12
        static let small: CGFloat = 9
    }
    //velocità sull'asse X
    enum XMovement {
        static let big: CGFloat = 5
        static let medium: CGFloat = 4
        static let small: CGFloat = 3
    }
    enum startingForce {
        static let medium: CGFloat = 5
        static let small: CGFloat = 5
    }
    enum scale {
        static let medium: CGFloat = 0.75
        static let small: CGFloat = 0.40
    }
    static let zRotation = Double.pi / 60
}


