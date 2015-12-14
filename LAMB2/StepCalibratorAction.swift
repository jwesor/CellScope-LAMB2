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
    let microstep: Bool
    let calib1: MotorCalibStepAction
    let calib2: MotorCalibStepAction

    convenience init(device: DeviceConnector, camera: CvCameraSession, stage: StageState, autofocus: AutofocuserAction? = nil) {
        let displacer = ImgDisplacementAction(camera: camera)
        if stage.isFovBounded() {
            stage.setImageProcessorRoiToFov(displacer.proc)
        }
        self.init(device: device, stage: stage, displacer: displacer, autofocus: autofocus)
    }
    
    init(device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction, microstep: Bool = false, autofocus: AutofocuserAction? = nil) {
        self.stage = stage
        self.microstep = microstep
        let range = microstep ? 30 : 10
        let micro = StageMicrostepAction(device, enabled: microstep, stage: stage)
        calib1 = MotorCalibStepAction(motor: StageConstants.MOTOR_1, device: device, stage: stage, displacer: displacer, range: range)
        calib2 = MotorCalibStepAction(motor: StageConstants.MOTOR_2, device: device, stage: stage, displacer: displacer, range: range)
        if autofocus != nil {
            super.init([micro, autofocus!, micro, calib1, autofocus!, micro, calib2, autofocus!])
        } else {
            super.init([micro, calib1, calib2])
        }
    }

    override func cleanup() {
        let M1 = StageConstants.MOTOR_1, M2 = StageConstants.MOTOR_2
        let HI = StageConstants.DIR_HIGH, LO = StageConstants.DIR_LOW
        stage.setBacklash(calib1.getBacklash(HI), motor: M1, dir: HI, microstep: microstep)
        stage.setBacklash(calib1.getBacklash(LO), motor: M1, dir: LO, microstep: microstep)
        stage.setBacklash(calib2.getBacklash(HI), motor: M2, dir: HI, microstep: microstep)
        stage.setBacklash(calib2.getBacklash(LO), motor: M2, dir: LO, microstep: microstep)
        stage.setStep(calib1.getAveStep(HI), motor: M1, dir: HI, microstep: microstep)
        stage.setStep(calib1.getAveStep(LO), motor: M1, dir: LO, microstep: microstep)
        stage.setStep(calib2.getAveStep(HI), motor: M2, dir: HI, microstep: microstep)
        stage.setStep(calib2.getAveStep(LO), motor: M2, dir: LO, microstep: microstep)
        
        print("Backlash M1 HI \(stage.getBacklash(M1, dir: HI, microstep: microstep))")
        print("Backlash M1 LO \(stage.getBacklash(M1, dir: LO, microstep: microstep))")
        print("Backlash M2 HI \(stage.getBacklash(M2, dir: HI, microstep: microstep))")
        print("Backlash M2 LO \(stage.getBacklash(M2, dir: LO, microstep: microstep))")
        print("Step M1 HI \(stage.getStep(M1, dir: HI, microstep: microstep))")
        print("Step M1 LO \(stage.getStep(M1, dir: LO, microstep: microstep))")
        print("Step M2 HI \(stage.getStep(M2, dir: HI, microstep: microstep))")
        print("Step M2 LO \(stage.getStep(M2, dir: LO, microstep: microstep))")
        super.cleanup()
    }
}