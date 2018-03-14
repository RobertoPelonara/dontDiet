//
//  GameViewController.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    
    // Create view
    if let view = self.view as! SKView? {

      // Create Scene
      let scene = MenuScene(size: view.frame.size)
      scene.scaleMode = .aspectFill // Fit the window

      // Debug
      view.ignoresSiblingOrder = false
      view.showsFPS = true
      view.showsNodeCount = true
      view.showsPhysics = true
        
      // Show Screen
      view.presentScene(scene)

    }

  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
