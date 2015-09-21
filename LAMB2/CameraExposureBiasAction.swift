//
//  CameraExposureBiasAction.swift
//  LAMB2
//
//  Instructs built-in camera to set exposure bias to the
//  specified value.
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
        do {
            try camera.captureDevice.lockForConfiguration()
            camera.captureDevice.setExposureTargetBias(bias, completionHandler: {
                (CMTime) -> Void in
                    self.finish()
            })
        } catch {
            print("unable to lock device for exposure configuration")
            finish()
        }
    }
}