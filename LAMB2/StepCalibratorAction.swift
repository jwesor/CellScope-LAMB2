//
//  StepCalibratorAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StepCalibratorAction: SequenceAction, ActionCompletionDelegate {
    
    let displacement: IPDisplacement
    let fov: IPFovBounds
    let fovAction: ImageProcessorAction
    let xCalibration: MotorStepCalibratorAction
    let yCalibration: MotorStepCalibratorAction
    let stage: StageState
    
    init(device: DeviceConnector, camera: CameraSession, stage: StageState) {
        displacement = IPDisplacement()
        fov = IPFovBounds()
        fovAction = ImageProcessorAction([fov], camera: camera);
        xCalibration = MotorStepCalibratorAction(StageConstants.MOTOR_2, device: device, camera: camera, stage: stage, ip: displacement)
        yCalibration = MotorStepCalibratorAction(StageConstants.MOTOR_1, device: device, camera: camera, stage: stage, ip: displacement)
        self.stage = stage
        super.init([fovAction, xCalibration, yCalibration])
        fovAction.addCompletionDelegate(self)
        xCalibration.addCompletionDelegate(self)
        yCalibration.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (action == fovAction) {
            displacement.croppingEnabled = true
            displacement.croppingCentered = false
            displacement.cropX = fov.x
            displacement.cropY = fov.y
            displacement.cropWidth = fov.width
            displacement.cropHeight = fov.height
        } else {
            var motor = (action == xCalibration) ? StageConstants.MOTOR_2 : StageConstants.MOTOR_1
            stage.motors[motor]!.backlash[StageConstants.DIR_HIGH] = xCalibration.backlashHighAction.backlashStepCounter
            stage.motors[motor]!.backlash[StageConstants.DIR_HIGH] = xCalibration.backlashLowAction.backlashStepCounter
            let highX = Int(round(xCalibration.stepHighAction.getAveX()))
            let highY = Int(round(xCalibration.stepHighAction.getAveY()))
            stage.motors[motor]!.step[StageConstants.DIR_LOW] = (x: highX, y: highY)
            let lowX = Int(round(xCalibration.stepLowAction.getAveX()))
            let lowY = Int(round(xCalibration.stepLowAction.getAveY()))
            stage.motors[motor]!.step[StageConstants.DIR_LOW] = (x: lowX, y: lowY)
        }
    }
    
}