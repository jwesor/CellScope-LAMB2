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

    let calibrator: StepCalibratorAction
    let autofocuser: AutofocuserAction
    let displacer: ImgDisplacementAction
    let fovBounds: ImgFovBoundsAction
    let backgrounder: ImgAcquireBackgroundAction
    let initAction: AbstractAction
    let initNoCalibAction: AbstractAction

    // Reusable actions for convenience
    private let motorEnable: [Int : StageEnableAction]
    private let motorDisable: [Int : StageDisableAction]
    private let dirhigh: [Int: StageDirectionAction]
    private let dirlow: [Int: StageDirectionAction]
    let microstep: StageMicrostepAction
    
    private(set) var x: Int = 0
    private(set) var y: Int = 0

    init(camera: CameraSession, device: DeviceConnector, stage: StageState) {
        self.camera = camera
        self.stage = stage
        self.device = device
        
        let enable1 = StageEnableAction(device, motor: StageConstants.MOTOR_1, stage: stage)
        let disable1 = StageDisableAction(device, motor: StageConstants.MOTOR_1, stage: stage)
        let enable2 = StageEnableAction(device, motor: StageConstants.MOTOR_2, stage: stage)
        let disable2 = StageDisableAction(device, motor: StageConstants.MOTOR_2, stage: stage)
        motorEnable = [StageConstants.MOTOR_1: enable1, StageConstants.MOTOR_2: enable2]
        motorDisable = [StageConstants.MOTOR_1: disable1, StageConstants.MOTOR_2: disable2]
        
        let dir1high = StageDirectionAction(device, motor: StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH, stage: stage)
        let dir1low = StageDirectionAction(device, motor: StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW, stage: stage)
        let dir2high = StageDirectionAction(device, motor: StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH, stage: stage)
        let dir2low = StageDirectionAction(device, motor: StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW, stage: stage)
        dirhigh = [StageConstants.MOTOR_1: dir1high, StageConstants.MOTOR_2: dir2high]
        dirlow = [StageConstants.MOTOR_1: dir1low, StageConstants.MOTOR_2: dir2low]
        
        autofocuser = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera:camera, device: device, stage: stage)
        backgrounder = ImgAcquireBackgroundAction(camera: camera)
        displacer = ImgDisplacementAction(camera: camera, displace: IPPyramidDisplacement(), preprocessors: [IPGradient()])
        fovBounds = ImgFovBoundsAction(camera: camera, stage: stage, bindRois:[displacer.proc, backgrounder.proc])
        calibrator = StepCalibratorAction(device: device, stage: stage, displacer: displacer, microstep: true)
        camera.addAsyncImageProcessor(displacer.proc)
        
        microstep = StageMicrostepAction(device, enabled: true, stage: stage)
        
        initAction = SequenceAction([autofocuser, fovBounds, calibrator, displacer])
        initNoCalibAction = SequenceAction([autofocuser, fovBounds, displacer])
        
        initAction.addCompletionDelegate(self)
        initNoCalibAction.addCompletionDelegate(self)
        displacer.addCompletionDelegate(self)
    }

    func reset() {
        x = 0
        y = 0
    }

    func onActionCompleted(action: AbstractAction) {
        if action === displacer {
            x += Int(displacer.dX)
            y += Int(displacer.dY)
            print("MFC \(x) \(y) \n", terminator: "")
        } else if action === initAction || action === initNoCalibAction {
            print("MFC reset")
            reset()
        }
    }
    
    func motorAction(motor: Int, enable: Bool) -> DeviceAction {
        if enable {
            return motorEnable[motor]!
        } else {
            return motorDisable[motor]!
        }
    }
    
    func directionAction(motor: Int, dir: Bool) -> StageDirectionAction {
        if dir == StageConstants.DIR_HIGH {
            return dirhigh[motor]!
        } else {
            return dirlow[motor]!
        }
    }
}