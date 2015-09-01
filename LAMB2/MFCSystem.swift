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
    
    // Reusable actions for convenience
    let enable1: StageEnableAction
    let disable1: StageDisableAction
    let enable2: StageEnableAction
    let disable2: StageDisableAction
    let enable: [Int: StageEnableAction]
    let disable: [Int: StageDisableAction]
    
    init(camera: CameraSession, device: DeviceConnector, stage: StageState, autofocus: AutofocuserAction? = nil) {
        self.camera = camera
        self.stage = stage
        self.device = device
        x = 0
        y = 0
        
        enable1 = StageEnableAction(device, motor: StageConstants.MOTOR_1, stage: stage)
        disable1 = StageDisableAction(device, motor: StageConstants.MOTOR_1, stage: stage)
        enable2 = StageEnableAction(device, motor: StageConstants.MOTOR_2, stage: stage)
        disable2 = StageDisableAction(device, motor: StageConstants.MOTOR_2, stage: stage)
        enable = [StageConstants.MOTOR_1: enable1, StageConstants.MOTOR_2: enable2]
        disable = [StageConstants.MOTOR_1: disable1, StageConstants.MOTOR_2: disable2]
        
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
        calibrator = StepCalibratorAction(device: device, camera: camera, stage: stage, autofocus: autofocuser)
        displacer = ImageProcessorAction([displacement], standby: 1)
        camera.addAsyncImageProcessor(displacer.proc)
        
        initAction = SequenceAction([calibrator, fovBounds, displacer])
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
            bounds.setBoundsAsRoi(displacement)
            displacement.roi = true
        } else if action == displacer {
            x += Int(displacement.dX)
            y += Int(displacement.dY)
            print("MFC \(x) \(y) \n")
        } else if action == initAction {
            reset()
        }
    }
}