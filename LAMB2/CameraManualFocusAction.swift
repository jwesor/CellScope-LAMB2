//
//  CameraManualFocusAction.swift
//  LAMB2
//
//  Action for manually setting the lens position of
//  the built-in camera.
//
//  Created by Fletcher Lab Mac Mini on 3/9/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraManualFocusAction : AbstractAction {
    
    let camera: CameraSession
    let lensPos: Float
    
    init(camera: CameraSession, lensPosition: Float) {
        self.camera = camera
        self.lensPos = lensPosition
        super.init()
    }
    
    override func doExecution() {
        var error:NSErrorPointer = nil
        if (camera.captureDevice.lockForConfiguration(error)) {
            camera.captureDevice.setFocusModeLockedWithLensPosition(lensPos) {
                (CMTime) -> Void in
                    self.finish()
            }
        } else {
            NSLog("unable to lock device for focus configuration %@", error.debugDescription)
            finish()
        }
    }
}