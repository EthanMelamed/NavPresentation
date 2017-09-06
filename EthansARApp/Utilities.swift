//
//  Utilities.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-09.
//  Copyright © 2017 Ethan . All rights reserved.
//

import Foundation
import ARKit

// MARK: - SCNVector3 extensions

extension SCNVector3 {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    static func add(v1: SCNVector3, v2: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
    }
    
}
