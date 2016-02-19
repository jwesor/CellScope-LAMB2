//
//  CameraAutoWhiteBalanceAction.swift
//  LAMB2
//
//  Instructs built-in camera to readjust white balance once.
//
//  Created by Fletcher Lab Mac Mini on 3/10/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class CameraAutoWhiteBalanceAction : AbstractAction {
    
    let camera: CameraSessionProtocol
    var autoOnOff: Bool
    
    init(_ camera: CameraSessionProtocol) {
        self.camera = camera
        autoOnOff = false
        super.init()
    }
    
    override func doExecution() {
        camera.captureDevice.addObserver(self, forKeyPath: "adjustingWhiteBalance", options: NSKeyValueObservingOptions.New, context: nil)
        if camera.captureDevice.whiteBalanceMode != AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance {
            let success = doSingleAutoWhiteBalance()
            if (!success) {
                // Seems like auto white balance is not currently supported. Here's a workaround that enables continuous auto white balance then goes back to locked
                autoOnOff = true
                setWhiteBalanceMode(AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance)
                if camera.captureDevice.whiteBalanceMode != AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance {
                    finish()
                }
            }
        }
    }
    
    private func doSingleAutoWhiteBalance() -> Bool {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
                print("Unable to lock device for configuration!")
                return false
            }
            if device.isWhiteBalanceModeSupported(AVCaptureWhiteBalanceMode.AutoWhiteBalance) {
                device.whiteBalanceMode = AVCaptureWhiteBalanceMode.AutoWhiteBalance
                device.unlockForConfiguration()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func setWhiteBalanceMode(mode: AVCaptureWhiteBalanceMode) {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
                print("Unable to lock device for configuration!")
                return
            }
            if device.isWhiteBalanceModeSupported(AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance) {
                device.whiteBalanceMode = AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance;
                device.unlockForConfiguration()
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "adjustingWhiteBalance") {
            if (change != nil) {
                let changedVal = change!
                let balancing = changedVal[NSKeyValueChangeNewKey]!.integerValue == 1;
                if (!balancing) {
                    //white balancing is done
                    if (self.autoOnOff) {
                        setWhiteBalanceMode(AVCaptureWhiteBalanceMode.Locked)
                    }
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
        camera.captureDevice.removeObserver(self, forKeyPath: "adjustingWhiteBalance")
    }
}