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
    
    init(device: DeviceConnector, camera: CameraSession, stage: StageState, autofocus: AutofocuserAction? = nil, enhancers: [ImageProcessor] = []) {
        displacement = IPDisplacement()
        fov = IPFovBounds()
        fovAction = ImageProcessorAction([fov], camera: camera);
        xCalibration = MotorStepCalibratorAction(StageConstants.MOTOR_2, device: device, camera: camera, stage: stage, ip: displacement, enhancers: enhancers)
        yCalibration = MotorStepCalibratorAction(StageConstants.MOTOR_1, device: device, camera: camera, stage: stage, ip: displacement, enhancers: enhancers)
        self.stage = stage
        if autofocus != nil {
            super.init([fovAction, autofocus!, xCalibration, autofocus!, yCalibration, autofocus!])
        } else {
            super.init([fovAction, xCalibration, yCalibration])
        }
        fovAction.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (action == fovAction) {
            displacement.roi = true
            fov.setBoundsAsRoi(displacement)
        }
    }
    
    override func cleanup() {
        let M1 = StageConstants.MOTOR_1, M2 = StageConstants.MOTOR_2
        let HI = StageConstants.DIR_HIGH, LO = StageConstants.DIR_LOW
        let cal2 = xCalibration, cal1 = yCalibration
        stage.setBacklash(cal1.getBacklash(HI), motor: M1, dir: HI)
        stage.setBacklash(cal1.getBacklash(LO), motor: M1, dir: LO)
        stage.setBacklash(cal2.getBacklash(HI), motor: M2, dir: HI)
        stage.setBacklash(cal2.getBacklash(LO), motor: M2, dir: LO)
        stage.setStep(cal1.getAveStep(HI), motor: M1, dir: HI)
        stage.setStep(cal1.getAveStep(LO), motor: M1, dir: LO)
        stage.setStep(cal2.getAveStep(HI), motor: M2, dir: HI)
        stage.setStep(cal2.getAveStep(LO), motor: M2, dir: LO)
        
        println("Backlash M1 HI \(stage.getBacklash(M1, dir: HI))")
        println("Backlash M1 LO \(stage.getBacklash(M1, dir: LO))")
        println("Backlash M2 HI \(stage.getBacklash(M2, dir: HI))")
        println("Backlash M2 LO \(stage.getBacklash(M2, dir: LO))")
        println("Step M1 HI \(stage.getStep(M1, dir: HI))")
        println("Step M1 LO \(stage.getStep(M1, dir: LO))")
        println("Step M2 HI \(stage.getStep(M2, dir: HI))")
        println("Step M2 LO \(stage.getStep(M2, dir: LO))")
        super.cleanup()
    }
}