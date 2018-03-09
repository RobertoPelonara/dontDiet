//
//  Background.swift
//  SKW
//
//  Copyright © 2018 Dario De Paolis. All rights reserved.
//

import SpriteKit

public class BackgroundNode: SKNode {

  public func setup(size: CGSize) {
    // Physics Ground
    let yPos: CGFloat = 20
    let startPoint = CGPoint(x: 0, y: yPos)
    let endPoint = CGPoint(x: size.width, y: yPos)
    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0.3
  }
  
}
