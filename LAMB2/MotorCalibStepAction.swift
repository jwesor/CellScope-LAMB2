//
//  MotorCalibStepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/18/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorCalibStepAction : SequenceAction {
    
    let stepHigh: StepDisplacementAction
    let stepLow: StepDisplacementAction
    let backlashHigh: DeadbandStepAction
    let backlashLow: DeadbandStepAction
    
    init(motor: Int, device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction, range: Int) {
        
        let enable = StageEnableAction(device, motor: motor, stage: stage)
        let disable = StageDisableAction(device, motor: motor, stage: stage)
        let dirLow = StageDirectionAction(device, motor: motor, dir: StageConstants.DIR_LOW, stage: stage)
        let dirHigh = StageDirectionAction(device, motor: motor, dir: StageConstants.DIR_HIGH, stage: stage)
        
        stepHigh = StepDisplacementAction(motor: motor, steps: range, device: device, stage: stage, displacer: displacer)
        stepLow = StepDisplacementAction(motor: motor, steps: range, device: device, stage: stage, displacer: displacer)
        
        backlashHigh = DeadbandStepAction(motor: motor, device: device, displacer: displacer)
        backlashLow = DeadbandStepAction(motor: motor, device: device, displacer: displacer)
        
        super.init([enable, dirHigh, backlashHigh, dirLow, backlashLow, stepLow, dirHigh, backlashHigh, stepHigh, disable])
    }
    
    func getBacklash(dir: Bool) -> Int {
        if dir == StageConstants.DIR_HIGH {
            return backlashHigh.stepCount
        } else {
            return backlashLow.stepCount
        }
    }
    
    func getAveStep(dir: Bool) -> (x: Int, y: Int) {
        let stepAction = (dir == StageConstants.DIR_HIGH) ? stepHigh : stepLow
        let x = Int(round(stepAction.aveX))
        let y = Int(round(stepAction.aveY))
        return (x: x, y: y)
    }
}