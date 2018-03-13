//
//  Vector2.swift
//  SKW
//
//  Created by Roberto Pelonara on 11/03/2018.
//  Copyright © 2018 Roberto Pelonara. All rights reserved.
//

import Foundation
import SpriteKit

struct Vector2 {
    
    var x: CGFloat
    var y: CGFloat
    
    mutating func normalize() {
        
        self.x = normalized().x
        self.y = normalized().y
    }
    
    func magnitude() -> CGFloat {
        
        return CGFloat(sqrtf( Float(x*x + y*y) ))
    }
    
    func dot( v: Vector2 ) -> CGFloat {
        
        return x * v.x + y * v.y
    }
    
    func normalized () -> Vector2 {
         var v = Vector2(x: x, y: y)
        
        let m = magnitude()
        
        if m > 0 {
            
            let normalFactor:CGFloat = 1.0 / m
            
            v.x *= normalFactor
            v.y *= normalFactor
        }
        return v
        
    }
    
    func scale (scalar: CGFloat) {
        
    }
    
    mutating func reflect (vector: Vector2)  {
        
        let n = normalized()
        let dotProduct = self.dot(v: vector.normalized())

        self = vector * (vector.normalized() * (dotProduct)) * CGFloat(-2)
        
        //r=v−2(v⋅n)n
        // Vect2 = Vect1 - 2 * WallN * (WallN DOT Vect1)
        
        
//        var vRet = new Vector2(x: 0, y: 0);
//        var dotP = v.dotProduct(n);
//        vRet.set( (v.getX() - (2*dotP*n.getX())), (v.getY() - (2*dotP*n.getY())) );
//        return vRet;
    }
    mutating func negate () {
        x = -x
        y = -y
    }
    
}



//Aggiunti TUTTI i calcoli possibili con i Vettori
func ==(lhs: Vector2, rhs: Vector2) -> Bool {
    
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

func * (left: Vector2, right : CGFloat) -> Vector2 {
    
    return Vector2(x:left.x * right, y:left.y * right)
}
func * (left: Vector2, right : Double) -> Vector2 {
    
    return Vector2(x:left.x * CGFloat(right), y:left.y * CGFloat(right))
}

func * (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x * right.x, y:left.y * right.y)
}

func / (left: Vector2, right : CGFloat) -> Vector2 {
    
    return Vector2(x:left.x / right, y:left.y / right)
}

func / (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x / right.x, y:left.y / right.y)
}

func + (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x + right.x, y:left.y + right.y)
}

func - (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x - right.x, y:left.y - right.y)
}

func + (left: Vector2, right: CGFloat) -> Vector2 {
    
    return Vector2(x:left.x + right, y:left.y + right)
}

func - (left: Vector2, right: CGFloat) -> Vector2 {
    
    return Vector2(x:left.x - right, y:left.y - right)
}

func += ( left: inout Vector2, right: Vector2) {
    
    left = left + right
}

func -= ( left: inout Vector2, right: Vector2) {
    
    left = left - right
}
func *= (left: inout Vector2, right : CGFloat) {
    
    left =  Vector2(x:left.x * right, y:left.y * right)
}

func *= ( left: inout Vector2, right: Vector2) {
    
    left = left * right
}

func /= ( left: inout Vector2, right: Vector2) {
    
    left = left / right
}
