//
//  CameraManualWhiteBalanceAction.swift
//  LAMB2
//
//  Instructs built-in camera to set white balance
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
        do {
            try camera.captureDevice.lockForConfiguration()
            camera.captureDevice.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(gains, completionHandler: {
                (CMTime) -> Void in
                    self.finish()
            })
        } catch {
            print("unable to lock device for white balance configuration")
            finish()
        }
    }
}