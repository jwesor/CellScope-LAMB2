//
//  CameraAutofocusAction.swift
//  LAMB2
//
//  Refocuses the camera using the built-in autofocus and
//  finishes when the autofocus is complete.
//
//  Created by Fletcher Lab Mac Mini on 3/9/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraAutofocusAction : AbstractAction {
    
    let camera: CameraSession
    
    init(camera: CameraSession) {
        self.camera = camera
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingFocus", options: NSKeyValueObservingOptions.New, context: nil)
        if (!camera.continuousAutofocus) {
            camera.doSingleAutofocus()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingFocus") {
            var focusing = change[NSKeyValueChangeNewKey]?.integerValue == 1;
            if (!focusing) {
                //Focusing is done
                camera.captureDevice.removeObserver(self, forKeyPath: "adjustingFocus")
                finish()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}