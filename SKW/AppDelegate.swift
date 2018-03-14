//
//  AppDelegate.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Load TextureAtlas
    let playerAtlas = SKTextureAtlas(named: "Sprites")
    
    // Get the list of texture names, and sort them
    let textureNames = playerAtlas.textureNames.sorted { (first, second) -> Bool in
        return first < second
    }
    
    // Load all textures
    GameManager.shared.allTextures = textureNames.map {
        return playerAtlas.textureNamed($0)
    }
    
    GameManager.shared.allDonutsTextures = GameManager.shared.allTextures.filter { (texture) -> Bool in
        return texture.description.contains("Donut")
    }
    
    GameManager.shared.initializeForks()
    GameManager.shared.initializeDonuts()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {

  }

  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillEnterForeground(_ application: UIApplication) {

  }

  func applicationDidBecomeActive(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {

  }

}
