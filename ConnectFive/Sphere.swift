//
//  Sphere.swift
//  BlastFive
//
//  Created by Bailey, Jennifer E. on 9/27/14.
//  Copyright (c) 2014 Aims. All rights reserved.
//

import SpriteKit

enum SphereType: Int, Printable
{
    case Grey=0, Green, Purple, Blue
    
    var spriteName: String {
        return "Sphere-"+NSString(format: "%02d",toRaw())
    }
    
    var description: String{
        return spriteName
    }
    
    static func random() -> SphereType {
        //arc for random upper bounds are exclusive
        return SphereType.fromRaw(Int(arc4random_uniform(4)))!
    }
}

class Sphere : Hashable {
    var column: Int
    var row: Int
    var sphereType : SphereType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, sphereType: SphereType)
    {
        self.column = column
        self.row = row
        self.sphereType = sphereType
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
    
}

func ==(lhs: Sphere, rhs: Sphere) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
