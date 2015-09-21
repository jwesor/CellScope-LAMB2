//
//  StepCalibratorAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StepCalibratorAction: SequenceAction {
    
    let stage: StageState
    let calib1: MotorCalibStepAction
    let calib2: MotorCalibStepAction

    convenience init(device: DeviceConnector, camera: CameraSession, stage: StageState, autofocus: AutofocuserAction? = nil) {
        let displacer = ImgDisplacementAction(camera: camera)
        if stage.isFovBounded() {
            stage.setImageProcessorRoiToFov(displacer.proc)
        }
        self.init(device: device, stage: stage, autofocus: autofocus, displacer: displacer)
    }
    
    init(device: DeviceConnector, stage: StageState, autofocus: AutofocuserAction? = nil, displacer: ImgDisplacementAction) {
        self.stage = stage
        let microOff = StageMicrostepAction(device, enabled: false, stage: stage)
        calib1 = MotorCalibStepAction(motor: StageConstants.MOTOR_1, device: device, stage: stage, displacer: displacer)
        calib2 = MotorCalibStepAction(motor: StageConstants.MOTOR_1, device: device, stage: stage, displacer: displacer)
        if autofocus != nil {
            super.init([microOff, autofocus!, calib1, autofocus!, calib2, autofocus!])
        } else {
            super.init([microOff, calib1, calib2])
        }
    }

    override func cleanup() {
        let M1 = StageConstants.MOTOR_1, M2 = StageConstants.MOTOR_2
        let HI = StageConstants.DIR_HIGH, LO = StageConstants.DIR_LOW
        stage.setBacklash(calib1.getBacklash(HI), motor: M1, dir: HI)
        stage.setBacklash(calib1.getBacklash(LO), motor: M1, dir: LO)
        stage.setBacklash(calib2.getBacklash(HI), motor: M2, dir: HI)
        stage.setBacklash(calib2.getBacklash(LO), motor: M2, dir: LO)
        stage.setStep(calib1.getAveStep(HI), motor: M1, dir: HI)
        stage.setStep(calib1.getAveStep(LO), motor: M1, dir: LO)
        stage.setStep(calib2.getAveStep(HI), motor: M2, dir: HI)
        stage.setStep(calib2.getAveStep(LO), motor: M2, dir: LO)
        
        print("Backlash M1 HI \(stage.getBacklash(M1, dir: HI))")
        print("Backlash M1 LO \(stage.getBacklash(M1, dir: LO))")
        print("Backlash M2 HI \(stage.getBacklash(M2, dir: HI))")
        print("Backlash M2 LO \(stage.getBacklash(M2, dir: LO))")
        print("Step M1 HI \(stage.getStep(M1, dir: HI))")
        print("Step M1 LO \(stage.getStep(M1, dir: LO))")
        print("Step M2 HI \(stage.getStep(M2, dir: HI))")
        print("Step M2 LO \(stage.getStep(M2, dir: LO))")
        super.cleanup()
    }
}