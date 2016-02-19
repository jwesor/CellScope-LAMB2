//
//  CameraStartSessionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/13/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraStartSessionAction: AbstractAction {
    
    let camera: CameraSessionProtocol
    private(set) var started: Bool = false
    
    init(_ camera: CameraSessionProtocol) {
        self.camera = camera
    }
    
    override func doExecution() {
        started = false
        if !camera.started {
            camera.startCameraSession()
            started = true
        }
        finish()
    }
    
}