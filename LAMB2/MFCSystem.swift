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
    let preprocessors: [ImageProcessor]

    private let calibrator: StepCalibratorAction
    private let fovBounds: ImgFovBoundsAction
    
    let autofocuser: AutofocuserAction
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
        
        (displacement, preprocessors) = MFCSystem.createDisplacerComponents()
        fovBounds = ImgFovBoundsAction(camera: camera, stage: stage)
        
        let initDisplacer = ImgDisplacementAction(camera: camera, displace: displacement, preprocessors: preprocessors)
        calibrator = StepCalibratorAction(device: device, stage: stage, displacer: initDisplacer, microstep: true)
        
        microstep = StageMicrostepAction(device, enabled: true, stage: stage)
        
        initAction = SequenceAction([autofocuser, fovBounds, calibrator, initDisplacer])
        initNoCalibAction = SequenceAction([autofocuser, fovBounds, initDisplacer])
        
        initAction.addCompletionDelegate(self)
        initNoCalibAction.addCompletionDelegate(self)
    }

    func reset() {
        setCurrentPosition(x: 0, y: 0)
    }

    func onActionCompleted(action: AbstractAction) {
        if action === initAction || action === initNoCalibAction {
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

    func setCurrentPosition(x x: Int, y: Int) {
        self.x = x
        self.y = y
        print("MFC \(x) \(y) \n", terminator: "")
    }

    func applyDisplacement(dX dX: Int, dY: Int) {
        x += dX
        y += dY
        print("MFC \(x) \(y) \n", terminator: "")
    }

    class func createDisplacerComponents() -> (displacement: IPDisplacement, preprocessors:[ImageProcessor]) {
        let displacement = IPPyramidDisplacement()
        let preprocessors = [IPGradient()]
        return (displacement, preprocessors)
    }
}