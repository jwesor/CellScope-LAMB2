//
//  MotorStepCalibratorAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorStepCalibratorAction : SequenceAction {
    
    let awayAction: StageEnableStepAction
    let returnAction: StageEnableStepAction
    let backlashAction: MotorBacklashCounterAction
    let steps: Int
    let camera: CameraSession
    
    init(_ motor: Int, device: DeviceConnector, camera: CameraSession, stage: StageState, range: UInt = 10) {
        awayAction = StageEnableStepAction(device, motor: motor, dir: StageConstants.DIR_HIGH, steps: range, stage: stage)
        returnAction = StageEnableStepAction(device, motor: motor, dir: StageConstants.DIR_LOW, steps: range, stage: stage)
        steps = Int(range)
        self.camera = camera
        backlashAction = MotorBacklashCounterAction(motor, dir: StageConstants.DIR_LOW, device: device, camera: camera, stage: stage)
        super.init([awayAction, backlashAction, returnAction])
    }
}