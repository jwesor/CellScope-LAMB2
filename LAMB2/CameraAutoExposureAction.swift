//
//  CameraAutoExposureAction.swift
//  LAMB2
//
//  Instructs built-in camera to automatically adjust
//  exposure once.
//
//  Created by Fletcher Lab Mac Mini on 3/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class CameraAutoExposureAction : AbstractAction {
    
    let camera: CameraSessionProtocol
    
    init(_ camera: CameraSessionProtocol) {
        self.camera = camera
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingExposure", options: NSKeyValueObservingOptions.New, context: nil)
        if camera.captureDevice.exposureMode != AVCaptureExposureMode.ContinuousAutoExposure {
            let success = doSingleAutoExposure()
            if (!success) {
                finish()
            }
        }
    }
    
    private func doSingleAutoExposure() -> Bool {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
                print("Unable to lock device for configuration!")
                return false
            }
            if device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
                device.exposureMode = AVCaptureExposureMode.AutoExpose
                device.unlockForConfiguration()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]? = nil, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingExposure") {
            if (change != nil) {
                let changedVal = change!
                let exposing = changedVal[NSKeyValueChangeNewKey]!.integerValue == 1;
                if (!exposing) {
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
        camera.captureDevice.removeObserver(self, forKeyPath: "adjustingExposure")
    }
}