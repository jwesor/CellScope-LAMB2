//
//  MFCSystem.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCSystem: ActionCompletionDelegate {
    
    let stage: StageState
    let camera: CameraSession
    let device: DeviceConnector
    let displacement: IPDisplacement
    let bounds: IPFovBounds
    let fovBounds: ImageProcessorAction
    let calibrator: StepCalibratorAction
    let autofocuser: AutofocuserAction
    let displacer: ImageProcessorAction
    let initAction: AbstractAction
    var x: Int
    var y: Int
    
    init(camera: CameraSession, device: DeviceConnector, stage: StageState, autofocus: AutofocuserAction? = nil) {
        self.camera = camera
        self.stage = stage
        self.device = device
        x = 0
        y = 0
        
        displacement = IPDisplacement()
        displacement.enabled = true
        bounds = IPFovBounds()
        bounds.enabled = true
        
        if (autofocus == nil) {
            autofocuser = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera:camera, device: device, stage: stage)
        } else {
            autofocuser = autofocus!
        }
        fovBounds = ImageProcessorAction([bounds], camera: camera)
        calibrator = StepCalibratorAction(device: device, camera: camera, stage: stage)
        displacer = ImageProcessorAction([displacement], standby: 1)
        camera.addAsyncImageProcessor(displacer.proc)
        
        initAction = SequenceAction([autofocuser, calibrator, fovBounds, displacer])
        initAction.addCompletionDelegate(self)
        fovBounds.addCompletionDelegate(self)
        displacer.addCompletionDelegate(self)
    }
    
    func reset() {
        x = 0
        y = 0
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action == fovBounds {
            displacement.cropX = bounds.x
            displacement.cropY = bounds.y
            displacement.cropWidth = bounds.width
            displacement.cropHeight = bounds.height
            displacement.croppingEnabled = true
        } else if action == displacer {
            x += Int(displacement.dX)
            y += Int(displacement.dY)
            print("MFC \(x) \(y) \n")
        } else if action == initAction {
            reset()
        }
    }
}