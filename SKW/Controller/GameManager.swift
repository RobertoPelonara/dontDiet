//
//  GameManager.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit
import  AVFoundation

class GameManager {
    
    static let shared = GameManager()
    
    var gameViewController: GameViewController?
    let eatSound = SKAction.playSoundFileNamed("eatDonut.mp3", waitForCompletion: false)
    var gameScene: GameScene?
    var menuScene: MenuScene?
    var endScene: EndScene?
    
    var startGameTimer: TimeInterval = 0
    var endGameTimer: TimeInterval = 0
    var totalGameTimer: TimeInterval = 0
    
    var deathReason: DeathReason?
    
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
            if _timer >= FatTimer.maxValue {_timer = FatTimer.maxValue}
            gameScene?.hud.timer = [newValue, _timer]
        }
    }
    
    var appCounted: Bool = false
    var monstersKills: Int = 0
    
    // Textures
    var allTextures: [SKTexture] = []
    var allBigDonutsTextures: [SKTexture] = []
    var allMediumDonutsTextures: [SKTexture] = []
    var allSmallDonutsTextures: [SKTexture] = []
    var allSmallPinkDonutsBreakTextures: [SKTexture] = []
    
    
    // Donuts
    var spawnedDonuts: [Donut] = []
    var spawnedForks: [Fork] = []
    
    //Broccoli
    var spawnedBroccoli: [Broccoli] = []
    var availableBroccoli: [Broccoli] = []
    
    var availableDonuts: [Donut] = []
    var availableForks: [Fork] = []
    
    private var _score: Int = 0
    private var _timer: TimeInterval = FatTimer.maxValue
    
    //Physics
    let gravity = CGPoint (x: 0, y: -0.4)
    var groundY = CGFloat(40)
    
    var soundtrack: AVAudioPlayer?
    
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
    
    func initializeBroccoli() {
        
        for _ in 0...4 {
            let broccoli = Broccoli()
            self.availableBroccoli.append(broccoli)
        }
    }
    
    func getBroccoli() -> Broccoli {
        if !self.availableBroccoli.isEmpty {
            
            let broccoli = self.availableBroccoli.removeFirst()
            return broccoli
            
        } else {
            
            let broccoli = Broccoli()
            return broccoli
            
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
    
    func gameOver (_ reason : DeathReason) {
        guard let _gameViewController = gameViewController,
        let _endScene = endScene,
        let _gameScene = gameScene else {
             return
        }
        deathReason = reason
        
        gameScene = nil
        self.endGameTimer = Date().timeIntervalSince1970
        totalGameTimer = self.endGameTimer - self.startGameTimer
        _gameViewController.loadScene(_endScene, _gameScene)
        
        availableDonuts.removeAll()
        availableForks.removeAll()
        spawnedForks.removeAll()
        spawnedDonuts.removeAll()
        _timer = FatTimer.maxValue
        if score > (gameViewController?.highestScore)! {
            gameViewController?.updateSavedScore(newScore: score)
            gameViewController?.highestScore = score
        }
        _score = 0
        

    }
    
    func addScore () {
        score += Scores.bonus
        gameScene!.run(self.eatSound)
        if !gameScene!.overdoseStarted{
        gameScene!.rushStarted = true
        gameScene!.rushCount += 1
        if gameScene!.rushCount >= gameScene!.donutToOverdose {
            gameScene!.startOverdose()
        }
        }
    }
    
    func addFat() {
        timer = FatTimer.bonus
    }
}

extension SKScene {
    
    func destroyScene () {
        print(self.children.count)
        removeAllChildren()
        print(self.children.count)
        removeAllActions()
        removeFromParent()
    }
    
}

