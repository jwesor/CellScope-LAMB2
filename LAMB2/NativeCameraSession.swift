//
//  NativeCameraSession.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/12/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class NativeCameraSession {
    
    let captureSession: AVCaptureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var captureDevice: AVCaptureDevice?
    
    init() {
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) && device.position == AVCaptureDevicePosition.Back {
                self.captureDevice = device as? AVCaptureDevice
            }
        }
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        stillImageOutput.highResolutionStillImageOutputEnabled = true
    }
    
    func startCameraSession() {
        do {
            let input: AVCaptureDeviceInput?
            try input = AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input!)
        } catch _ {
            print("Error starting native camera!")
        }
        captureSession.addOutput(stillImageOutput)
        captureSession.startRunning()
    }
    
    func stopCameraSession() {
        captureSession.stopRunning()
        captureSession.removeOutput(stillImageOutput)
    }
    
}