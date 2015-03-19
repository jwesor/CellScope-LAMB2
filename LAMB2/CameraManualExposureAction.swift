//
//  CameraManualExposureAction.swift
//  LAMB2
//
//  Instructs built-in camera to set exposure to the specified
//  settings.
//
//  Created by Fletcher Lab Mac Mini on 3/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraManualExposureAction : AbstractAction {
    
    let camera: CameraSession
    let dur: CMTime
    let iso: Float
    
    init(camera: CameraSession, milliseconds: Int64, iso: Float) {
        self.camera = camera
        self.dur = CMTime(value: milliseconds, timescale: 1000, flags: nil, epoch: 0)
        self.iso = iso
        super.init()
    }
    
    init(camera: CameraSession, duration: CMTime, iso: Float) {
        self.camera = camera
        self.dur = duration
        self.iso = iso
        super.init()
    }
    
    override func doExecution() {
        var error:NSErrorPointer = nil
        if (camera.captureDevice.lockForConfiguration(error)) {
            camera.captureDevice.setExposureModeCustomWithDuration(dur, ISO: iso, completionHandler: {
                (CMTime) -> Void in
                    self.finish()
            })
        } else {
            NSLog("unable to lock device for exposure configuration %@", error.debugDescription)
            finish()
        }
    }
}