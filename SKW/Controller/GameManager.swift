//
//  GameManager.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class GameManager {
  static let shared = GameManager()

  var score: Int = 0
  var appCounted: Bool = false
  var monstersKills: Int = 0
  var timerCounter: Int = 30

  // Textures
  var allTextures: [SKTexture] = []
    var allDonutsTextures: [SKTexture] = []

  // Donuts
    var spawnedDonuts: [Donut] = []
    
    var spawnedForks: [Fork] = []
    
    //Physics
    let gravity = CGPoint (x: 0, y: -0.4)
    let groundY = CGFloat(70)
}

