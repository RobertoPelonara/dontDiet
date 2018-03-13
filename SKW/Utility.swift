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
    
    let circleDistanceX = abs(circle.x - rect.x)
    let circleDistanceY = abs(circle.y - rect.y)
    
    if (circleDistanceX > (rect.width/2 + circle.r)) { return false }
    if (circleDistanceY > (rect.height/2 + circle.r)) { return false }
    
    if (circleDistanceX <= (rect.width/2)) { return true }
    if (circleDistanceY <= (rect.height/2)) { return true }
    
    let cornerDistance_sq = pow((circleDistanceX - rect.width/2), 2) +
        pow((circleDistanceY - rect.height/2), 2)
    
    return (cornerDistance_sq <= pow(circle.r, 2))

}


/**
 Tratta due CGPoint come se fossero vettori
*/

