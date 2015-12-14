//
//  NativeCameraSession.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/12/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class NativeCameraSession: CameraSessionProtocol {
    
    let captureSession: AVCaptureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var input: AVCaptureDeviceInput?
    @objc private(set) var started: Bool = false
    @objc var captureDevice: AVCaptureDevice?
    
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
    
    @objc func startCameraSession() {
        do {
            try input = AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input!)
        } catch _ {
            print("Error starting native camera!")
        }
        captureSession.addOutput(stillImageOutput)
        captureSession.startRunning()
        started = true
    }
    
    @objc func stopCameraSession() {
        captureSession.stopRunning()
        captureSession.removeOutput(stillImageOutput)
        if let captureInput = input {
            captureSession.removeInput(captureInput)
        }
        started = false
    }
    
}