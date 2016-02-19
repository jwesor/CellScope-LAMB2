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
    
    let camera: CameraSessionProtocol
    let dur: CMTime
    let iso: Float
    
    init(_ camera: CameraSessionProtocol, milliseconds: Int64, iso: Float) {
        self.camera = camera
        self.dur = CMTime(value: milliseconds, timescale: 1000, flags: [], epoch: 0)
        self.iso = iso
        super.init()
    }
    
    init(camera: CameraSessionProtocol, duration: CMTime, iso: Float) {
        self.camera = camera
        self.dur = duration
        self.iso = iso
        super.init()
    }
    
    override func doExecution() {
        do {
            try camera.captureDevice.lockForConfiguration()
            camera.captureDevice.setExposureModeCustomWithDuration(dur, ISO: iso, completionHandler: {
                (CMTime) -> Void in
                self.finish()
            })
        } catch {
            print("unable to lock device for exposure configuration")
            finish()
        }
    }
}