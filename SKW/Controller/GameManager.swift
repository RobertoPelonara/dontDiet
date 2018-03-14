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
    
    var availableDonuts: [Donut] = []
    var spawnedDonuts2: [Donut] = []
    
    var availableForks: [Fork] = []
    var spawnedForks2:[Fork] = []
    
    //Physics
    let gravity = CGPoint (x: 0, y: -0.4)
    let groundY = CGFloat(70)
    
    func initializeDonuts(){
        
        for _ in 0...40 {
            
            let donut = Donut()
            donut.isInGame = false
            self.availableDonuts.append(donut)
            
        }
    }
    
    func initializeForks() {
        
        for _ in 0...5 {
            
            let fork = Fork()
            fork.isInGame = false
            self.availableForks.append(fork)
        }
    }
    
    func getDonut() -> Donut {
        
        if let donut = availableDonuts.first(where: {$0.isInGame == false}) {
            
            return donut
            
        } else {
            
            let donut = Donut()
            donut.isInGame = false
            self.availableDonuts.append(donut)
            return donut
        }
    }
    
    func getFork() -> Fork {
        
        if let fork = availableForks.first(where: {$0.isInGame == false}){
            
            return fork
            
        } else {
            
            let fork = Fork()
            fork.isInGame = false
            self.availableForks.append(fork)
            return fork
        }
        
    }
    
}

