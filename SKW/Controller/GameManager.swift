//
//  GameManager.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

class GameManager {
    
    static let shared = GameManager()
    
    var gameViewController: GameViewController?
    
    var gameScene: GameScene?
    var menuScene: MenuScene?
    var endScene: EndScene?
    
    var startGameTimer: TimeInterval = 0
    var endGameTimer: TimeInterval = 0
    var totalGameTimer: TimeInterval = 0
    
    var score: Int{
        get {
            return _score
        }
        set {
            _score = newValue
            gameScene?.hud.score = _score
        }
    }
    
    var timer: TimeInterval {
        get {
            return _timer
        }
        set {
            _timer += newValue
            gameScene?.hud.timer = _timer
        }
    }
    
    var appCounted: Bool = false
    var monstersKills: Int = 0
    
    // Textures
    var allTextures: [SKTexture] = []
    var allDonutsTextures: [SKTexture] = []
    
    // Donuts
    var spawnedDonuts: [Donut] = []
    var spawnedForks: [Fork] = []
    
    var availableDonuts: [Donut] = []
    var availableForks: [Fork] = []
    
    private var _score: Int = 0
    private var _timer: TimeInterval = FatTimer.maxValue
    
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
    
    func gameOver () {
        guard let _gameViewController = gameViewController,
        let _endScene = endScene,
        let _gameScene = gameScene else {
             return
        }
        self.endGameTimer = Date().timeIntervalSince1970
        
        totalGameTimer = self.endGameTimer - self.startGameTimer
        _gameViewController.loadScene(_endScene)

    }
    
    func addScore () {
        score += Scores.bonus
    }
    
    func addFat() {
        timer = FatTimer.bonus
    }
}

