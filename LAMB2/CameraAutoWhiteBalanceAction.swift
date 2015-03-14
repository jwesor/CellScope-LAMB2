//
//  CameraAutoWhiteBalanceAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/10/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraAutoWhiteBalanceAction : AbstractAction {
    
    let camera: CameraSession
    var autoOnOff: Bool
    
    init(camera: CameraSession) {
        self.camera = camera
        autoOnOff = false
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingWhiteBalance", options: NSKeyValueObservingOptions.New, context: nil)
        if (!camera.continuousAutoWhiteBalance) {
            let success = camera.doSingleAutoWhiteBalance()
            if (!success) {
                // Seems like auto white balance is not currently supported. Here's a workaround that enables continuous auto white balance then goes back to locked
                autoOnOff = true
                camera.continuousAutoWhiteBalance = true
                if (!camera.continuousAutoWhiteBalance) {
                    finish()
                }
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingWhiteBalance") {
            var balancing = change[NSKeyValueChangeNewKey]?.integerValue == 1;
            if (!balancing) {
                //white balancing is done
                if (self.autoOnOff) {
                    camera.continuousAutoWhiteBalance = false
                }
                finish()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    override func cleanup() {
        camera.captureDevice.removeObserver(self, forKeyPath: "adjustingWhiteBalance")
    }
}