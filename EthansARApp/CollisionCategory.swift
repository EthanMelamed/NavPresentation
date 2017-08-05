//
//  CollisionCategory.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-05.
//  Copyright © 2017 Ethan . All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let bottom = CollisionCategory(rawValue: 1 << 0)
    static let cube = CollisionCategory(rawValue: 1 << 1)
}

