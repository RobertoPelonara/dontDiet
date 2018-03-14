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
    var availableForks: [Fork] = []
    
    
    //Physics
    let gravity = CGPoint (x: 0, y: -0.4)
    let groundY = CGFloat(40)
    
    func initializeDonuts(){
        
        for i in 0...39 {
            
            let donut = Donut()
            //donut.isInGame = false
            donut.indexInArray = i
            self.availableDonuts.append(donut)
            
        }
    }
    
    func initializeForks() {
        
        for i in 0...4 {
            
            let fork = Fork()
            //fork.isInGame = false
            fork.indexInArray = i
            self.availableForks.append(fork)
        }
    }
    
    func getDonut() -> Donut {
        
        if !self.availableDonuts.isEmpty{
            
            let donut = self.availableDonuts.removeFirst()
            return donut
            
            
        } else {
            
            let donut = Donut()
            return donut
        }
    }
    
    func getFork() -> Fork {
        
        if !self.availableForks.isEmpty{
            
            let fork = self.availableForks.removeFirst()
            return fork

            
        } else {
            
            let fork = Fork()
            return fork 
        }
        
    }
    
}

