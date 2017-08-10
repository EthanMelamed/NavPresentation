//
//  Airplane.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-09.
//  Copyright © 2017 Ethan . All rights reserved.
//

import Foundation

class Airplane: VirtualObject {
    
    override init() {
        super.init(modelName: "airplane", fileExtension: "scn", thumbImageFilename: "airplane", title: "Airplane")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

