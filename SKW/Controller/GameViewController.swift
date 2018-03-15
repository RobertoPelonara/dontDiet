//
//  GameViewController.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var highestScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate().persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
//        let entity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)
//        let score = NSManagedObject(entity: entity!, insertInto: managedContext)
//
//        score.setValue(0, forKey: "highestScore")
//        do{
//            try self.managedContext.save()
//            print("row created")
//        } catch let error as NSError {
//            print("a bucchin e mammt \(error) , \(error.userInfo)")
//        }
        do{
            let result = try self.managedContext.fetch(request)
            let score = result[0] as! NSManagedObject

            print("the fetched value is: \(score.value(forKey: "highestScore"))")
//            highestScore = score.value(forKey: "highestScore") as! Int

        }catch {
            fatalError("Failed to fetch player : \(error)")
        }
        
        GameManager.shared.gameViewController = self
        let endScene = EndScene(size: view.frame.size)
        GameManager.shared.endScene = endScene
        
        let scene = MenuScene(size: view.frame.size)
        GameManager.shared.menuScene = scene
        
        loadScene(scene, nil)
        
        
    }
    
    func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func loadScene (_ scene: SKScene, _ currentScene: SKScene?) {
        // Create view
        if let view = self.view as! SKView? {
            
            if let _currentScene = currentScene {
                _currentScene.destroyScene()
            }
            
            
            // Create Scene
            //let scene = MenuScene(size: view.frame.size)
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
