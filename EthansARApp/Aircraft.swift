//
//  Airplane.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-09.
//  Copyright © 2017 Ethan . All rights reserved.
//

import Foundation
import SceneKit

class Aircraft: VirtualObject {
    
    override init() {
        super.init(modelName: "737-700", fileExtension: "scn", thumbImageFilename: "aircraft", title: "aircraft")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAircraftModel() {
        guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "Assets.scnassets/aircraft/\(modelName)") else {
            return
        }
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            child.movabilityHint = .movable
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
        
        modelLoaded = true
    }
    func getHeight() -> Float{
        return abs(self.boundingBox.max.y - self.boundingBox.min.y)
    }
}


