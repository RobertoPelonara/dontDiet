//
//  AppDelegate.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Load TextureAtlas
        let playerAtlas = SKTextureAtlas(named: "Sprites")
        print(playerAtlas)
        
        
        
        // Get the list of texture names, and sort them
        let textureNames = playerAtlas.textureNames.sorted { (first, second) -> Bool in
            return first < second
        }
        
        // Load all textures
        GameManager.shared.allTextures = textureNames.map {
            return playerAtlas.textureNamed($0)
        }
        
        GameManager.shared.allBigDonutsTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("donut_big")
        }
        GameManager.shared.allMediumDonutsTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("donut_medium")
        }
        GameManager.shared.allSmallDonutsTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("donut_small")
        }
        GameManager.shared.allSmallPinkDonutsBreakTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("donut_breaks_pink")
        }
        GameManager.shared.allSmallDonutsAuraTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("aura_small")
        }
        GameManager.shared.allMidDonutsAuraTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("aura_mid")
        }
        GameManager.shared.allBigDonutsAuraTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
            return texture.description.contains("aura_big")
        }
        
        //shared actions
        GameManager.shared.sceneStop = SKAction.run {
            
            GameManager.shared.gameScene?.tapisRoulant.removeAllActions()
            for donut in GameManager.shared.spawnedDonuts {
                donut.auraNode?.removeAllActions()
                
            }
            
            GameManager.shared.gamePaused = true
            GameManager.shared.gameScene?.perna.removeAllActions()
            GameManager.shared.gameScene?.perna.removeAllChildren()
            GameManager.shared.gameScene?.perna.size = SpriteSize.playerDying
            GameManager.shared.gameScene?.perna.setScale(0.65)
            GameManager.shared.gameScene?.perna.position.y -= 5
            GameManager.shared.gameScene?.perna.texture = GameManager.shared.gameScene?.perna.textureDeath[0]
            
        }
        
        GameManager.shared.sceneResume = SKAction.run {
            
            GameManager.shared.gameIsOver = true
            GameManager.shared.gameScene?.perna.run(SKAction.repeatForever(SKAction.animate(with: (GameManager.shared.gameScene?.perna.textureDeath)!, timePerFrame: 0.1)))
            
        }
        
        GameManager.shared.wait = SKAction.wait(forDuration: AnimationSpeeds.deathAnimationWaitTime)
        
        GameManager.shared.gameOverSequence = SKAction.sequence([GameManager.shared.sceneStop, GameManager.shared.wait, GameManager.shared.sceneResume])
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        GameManager.shared.gamePaused = true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        GameManager.shared.gameScene?.lastTime = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if !GameManager.shared.gameIsOver && !GameManager.shared.firstTime { GameManager.shared.gamePaused = false }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "dontDiet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

