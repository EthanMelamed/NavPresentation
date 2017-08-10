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
}
