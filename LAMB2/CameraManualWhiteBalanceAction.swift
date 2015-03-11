//
//  CameraManualWhiteBalanceAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/10/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraManualWhiteBalanceAction : AbstractAction {
    
    let camera: CameraSession
    let gains: AVCaptureWhiteBalanceGains
    
    init(camera: CameraSession, red: Float, green: Float, blue: Float) {
        self.camera = camera
        self.gains = AVCaptureWhiteBalanceGains(redGain: red, greenGain: green, blueGain: blue)
        super.init()
    }
    
    init(camera: CameraSession, gains: AVCaptureWhiteBalanceGains) {
        self.camera = camera
        self.gains = gains
        super.init()
    }
    
    override func doExecution() {
        var error:NSErrorPointer = nil
        if (camera.captureDevice.lockForConfiguration(error)) {
            camera.captureDevice.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(gains, completionHandler: {
                (CMTime) -> Void in
                    self.finish()
            })
        } else {
            NSLog("unable to lock device for white balance configuration %@", error.debugDescription)
            finish()
        }
    }
}