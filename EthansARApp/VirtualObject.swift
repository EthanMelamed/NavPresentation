//
//  VirtualObject.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-09.
//  Copyright © 2017 Ethan . All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class VirtualObject: SCNNode {
    
    var modelName: String = ""
    var fileExtension: String = ""
    var thumbImage: UIImage!
    var title: String = ""
    var modelLoaded: Bool = false
    
    var viewController: ViewController?
    
    override init() {
        super.init()
        self.name = "Virtual object root node"
    }
    
    init(modelName: String, fileExtension: String, thumbImageFilename: String, title: String) {
        super.init()
        self.name = "Virtual object root node"
        self.modelName = modelName
        self.fileExtension = fileExtension
        self.thumbImage = UIImage(named: thumbImageFilename)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "Assets.scnassets/\(modelName)") else {
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
    
    func unloadModel() {
        for child in self.childNodes {
            child.removeFromParentNode()
        }
        
        modelLoaded = false
    }
}

extension VirtualObject {
    static let availableObjects: [VirtualObject] = [
        Aircraft()
    ]
}
