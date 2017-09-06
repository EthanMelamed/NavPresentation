//
//  PBRMaterial.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-05.
//  Copyright © 2017 Ethan . All rights reserved.
//

import UIKit
import SceneKit

var materials: [String:SCNMaterial] = [:]

class PBRMaterial: NSObject {
    class func materialNamed(name: String) -> SCNMaterial {
        var mat = materials[name]
        if let mat = mat {
            return mat
        }
        
        mat = SCNMaterial()
        mat!.lightingModel = SCNMaterial.LightingModel.physicallyBased
        mat!.diffuse.contents = UIImage(named: "./Assets.scnassets/Materials/\(name)/\(name)-albedo.png")
        mat!.roughness.contents = UIImage(named: "./Assets.scnassets/Materials/\(name)/\(name)-roughness.png")
        mat!.metalness.contents = UIImage(named: "./Assets.scnassets/Materials/\(name)/\(name)-metal.png")
        mat!.normal.contents = UIImage(named: "./Assets.scnassets/Materials/\(name)/\(name)-normal.png")
        mat!.diffuse.wrapS = SCNWrapMode.repeat
        mat!.diffuse.wrapT = SCNWrapMode.repeat
        mat!.roughness.wrapS = SCNWrapMode.repeat
        mat!.roughness.wrapT = SCNWrapMode.repeat
        mat!.metalness.wrapS = SCNWrapMode.repeat
        mat!.metalness.wrapT = SCNWrapMode.repeat
        mat!.normal.wrapS = SCNWrapMode.repeat
        mat!.normal.wrapT = SCNWrapMode.repeat
        
        materials[name] = mat
        return mat!
    }
    class func getDebugMaterial(name: String) -> SCNMaterial {
        var mat = materials[name]
        if let mat = mat {
            return mat
        }
        mat = SCNMaterial()
        mat!.lightingModel = SCNMaterial.LightingModel.physicallyBased
        mat!.diffuse.contents = UIImage(named: "./Assets.scnassets/Materials/debug/\(name).png")
        mat!.diffuse.wrapS = SCNWrapMode.repeat
        mat!.diffuse.wrapT = SCNWrapMode.repeat
        materials[name] = mat
        return mat!
    }
    class func getRunwayMaterial() -> SCNMaterial {
        let name = "runway"
        var mat = materials[name]
        if let mat = mat {
            return mat
        }
        mat = SCNMaterial()
        mat!.lightingModel = SCNMaterial.LightingModel.physicallyBased
        mat!.diffuse.contents = UIImage(named: "./Assets.scnassets/Materials/runway/runway.jpg")
        mat!.diffuse.wrapS = SCNWrapMode.repeat
        mat!.diffuse.wrapT = SCNWrapMode.repeat
        materials[name] = mat
        return mat!
    }
}
