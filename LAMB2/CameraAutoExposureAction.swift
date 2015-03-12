//
//  CameraAutoExposureAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraAutoExposureAction : AbstractAction {
    
    let camera: CameraSession
    
    init(camera: CameraSession) {
        self.camera = camera
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingExposure", options: NSKeyValueObservingOptions.New, context: nil)
        if (!camera.continuousAutoExposure) {
            let success = camera.doSingleAutoExposure()
            if (!success) {
                camera.captureDevice.removeObserver(self, forKeyPath: "adjustingExposure")
                finish()
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingExposure") {
            var exposing = change[NSKeyValueChangeNewKey]?.integerValue == 1;
            if (!exposing) {
                camera.captureDevice.removeObserver(self, forKeyPath: "adjustingExposure")
                finish()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}