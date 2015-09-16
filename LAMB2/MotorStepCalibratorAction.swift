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
    
    init(_ motor: Int, device: DeviceConnector, camera: CameraSession, stage: StageState, range: UInt = 10, microstep: Bool = false, ip: IPDisplacement? = nil, enhancers: [ImageProcessor] = []) {
        steps = Int(range)
        self.camera = camera
        backlashHighAction = MotorBacklashCounterAction(motor, dir: StageConstants.DIR_HIGH, device: device, camera: camera, stage: stage, ip: ip, enhancers: enhancers)
        backlashLowAction = MotorBacklashCounterAction(motor, dir: StageConstants.DIR_LOW, device: device, camera: camera, stage: stage, ip: ip, enhancers: enhancers)
        stepHighAction = MotorStepDisplacementAction(motor, dir: StageConstants.DIR_HIGH, steps: steps, device: device, camera: camera, stage: stage, ip: ip, enhancers: enhancers)
        stepLowAction = MotorStepDisplacementAction(motor, dir: StageConstants.DIR_LOW, steps: steps, device: device, camera: camera, stage: stage, ip: ip, enhancers: enhancers)
        if microstep {
            let microEnable = StageMicrostepAction(device, enabled: true, stage: stage)
            let microDisable = StageMicrostepAction(device, enabled: false, stage: stage)
            super.init([microDisable, backlashHighAction, microEnable, backlashLowAction, stepLowAction, backlashHighAction, stepHighAction])
        } else {
            super.init([backlashHighAction, backlashLowAction, stepLowAction, backlashHighAction, stepHighAction])
        }
    }
    
    func getBacklash(dir: Bool) -> Int {
        if dir == StageConstants.DIR_HIGH {
            return backlashHighAction.backlashStepCounter
        } else {
            return backlashLowAction.backlashStepCounter
        }
    }
    
    func getAveStep(dir: Bool) -> (x: Int, y: Int) {
        if dir == StageConstants.DIR_HIGH {
            let x = Int(round(stepHighAction.getAveX()))
            let y = Int(round(stepHighAction.getAveY()))
            return (x: x, y: y)
        } else {
            let x = Int(round(stepLowAction.getAveX()))
            let y = Int(round(stepLowAction.getAveY()))
            return (x: x, y: y)
        }
    }
}