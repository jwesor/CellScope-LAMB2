//
//  MotorStepCalibratorAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorStepCalibratorAction : SequenceAction {
    
    let stepHighAction: MotorStepDisplacementAction
    let stepLowAction: MotorStepDisplacementAction
    let backlashHighAction: MotorBacklashCounterAction
    let backlashLowAction: MotorBacklashCounterAction
    let steps: Int
    let camera: CameraSession
    
    init(_ motor: Int, device: DeviceConnector, camera: CameraSession, stage: StageState, range: UInt = 5, ip: IPDisplacement? = nil) {
        steps = Int(range)
        self.camera = camera
        backlashHighAction = MotorBacklashCounterAction(motor, dir: StageConstants.DIR_HIGH, device: device, camera: camera, stage: stage, ip: ip)
        backlashLowAction = MotorBacklashCounterAction(motor, dir: StageConstants.DIR_LOW, device: device, camera: camera, stage: stage, ip: ip)
        stepHighAction = MotorStepDisplacementAction(motor, dir: StageConstants.DIR_HIGH, steps: steps, device: device, camera: camera, stage: stage, ip: ip)
        stepLowAction = MotorStepDisplacementAction(motor, dir: StageConstants.DIR_LOW, steps: steps, device: device, camera: camera, stage: stage, ip: ip)
        super.init([backlashHighAction, backlashLowAction, stepLowAction, backlashHighAction, stepHighAction])
    }
}