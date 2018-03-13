//
//  Utility.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import Foundation
import SpriteKit

struct Circle {
    var x: CGFloat
    var y: CGFloat
    var r: CGFloat
    
    init(x: CGFloat, y: CGFloat, radius: CGFloat) {
        self.x = x
        self.y = y
        self.r = radius
    }
}

struct Rect {
    var x: CGFloat
    var y: CGFloat
    var height: CGFloat
    var width: CGFloat
    
}

func rectInCircle (rect: Rect, circle: Circle) -> Bool {
    
    let nearestX = max(rect.x, min(circle.x, rect.x + rect.width/2))
    let nearestY = max(rect.y, min(circle.y, rect.x + rect.height/2))
    let deltaX = circle.x - nearestX
    let deltaY = circle.y - nearestY
    
    return (pow(deltaX,1) + pow(deltaY, 1) <= (pow(circle.r, 1)))

}


/**
 Tratta due CGPoint come se fossero vettori
*/

