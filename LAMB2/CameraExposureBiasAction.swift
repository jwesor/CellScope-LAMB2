//
//  CameraExposureBiasAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraExposureBiasAction : AbstractAction {
    
    let camera: CameraSession
    let bias: Float
    
    init(camera: CameraSession, bias: Float) {
        self.camera = camera
        self.bias = bias
        super.init()
    }
    
    override func doExecution() {
        var error:NSErrorPointer = nil
        if (camera.captureDevice.lockForConfiguration(error)) {
            camera.captureDevice.setExposureTargetBias(bias, completionHandler: {
                (CMTime) -> Void in
                    self.finish()
            })
        } else {
            NSLog("unable to lock device for exposure configuration %@", error.debugDescription)
            finish()
        }
    }
}