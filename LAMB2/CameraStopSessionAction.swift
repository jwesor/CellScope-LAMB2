//
//  CameraStopSessionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/13/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraStopSessionAction: AbstractAction {
    
    let camera: CameraSessionProtocol
    private(set) var stopped: Bool = false
    
    init(_ camera: CameraSessionProtocol) {
        self.camera = camera
    }
    
    override func doExecution() {
        stopped = false
        if camera.started {
            camera.stopCameraSession()
            stopped = true
        }
        finish()
    }
    
}