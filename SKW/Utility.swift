//
//  Utility.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import Foundation
import SpriteKit

class CGCircle {
    var x: CGFloat
    var y: CGFloat
    var r: CGFloat
    
    init(x: CGFloat, y: CGFloat, radius: CGFloat) {
        self.x = x
        self.y = y
        self.r = radius
    }
}

func rectInCircle (rect: CGRect, circle: CGCircle) -> Bool {
    var circleDistance = CGPoint()
    
    circleDistance.x = fabs(circle.x - rect.midX)
    circleDistance.y = fabs(circle.y - rect.midY)
    
    // Considerare di usare >= per la tangenza
    if (circleDistance.x > (rect.width/2 + circle.r)) { return false }
    if (circleDistance.y > (rect.height/2 + circle.r)) { return false }
    
    if (circleDistance.x <= (rect.width/2)) { return true }
    if (circleDistance.y <= (rect.height/2)) { return true }
    
    let cornerDistance_sq = pow(circleDistance.x - rect.width/2, 2) +
        pow(circleDistance.y - rect.height/2, 2);
    
    return (cornerDistance_sq <= pow(circle.r, 2));
}


/**
 Tratta due CGPoint come se fossero vettori
*/

