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
  static let sprites: CGFloat = 10.0
  static let HUD: CGFloat = 100.0
}

enum SpriteSize {
  static let player = CGSize(width: 64, height: 64)
  static let enemy = CGSize(width: 30, height: 30)
  static let bullet = CGSize(width: 10, height: 10)
  static let mushroom = CGSize(width: 20, height: 20)
  static let button = CGSize(width: 50, height: 50)
}

enum Scores {
  static let bonus = 10
  static let malus = -10
}
