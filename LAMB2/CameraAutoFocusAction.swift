//
//  CameraAutoFocusAction.swift
//  LAMB2
//
//  Refocuses the camera using the built-in autofocus and
//  finishes when the autofocus is complete.
//
//  Created by Fletcher Lab Mac Mini on 3/9/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class CameraAutoFocusAction : AbstractAction {
    
    let camera: CameraSessionProtocol
    
    init(_ camera: CameraSessionProtocol) {
        self.camera = camera
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingFocus", options: NSKeyValueObservingOptions.New, context: nil)
        if (camera.captureDevice.focusMode != AVCaptureFocusMode.ContinuousAutoFocus) {
            let success = doSingleAutoFocus()
            if (!success) {
                finish()
            }
        }
    }
    
    private func doSingleAutoFocus() -> Bool {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
                print("Unable to lock device for configuration!")
                return false
            }
            if device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
                device.focusMode = AVCaptureFocusMode.AutoFocus
                device.unlockForConfiguration()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingFocus") {
            if (change != nil) {
                let changedVal = change!
                let focusing = changedVal[NSKeyValueChangeNewKey]!.integerValue == 1;
                if (!focusing) {
                    //Focusing is done
                    finish()
                }
            } else {
                finish()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    override func cleanup() {
        camera.captureDevice.removeObserver(self, forKeyPath: "adjustingFocus")
    }
}