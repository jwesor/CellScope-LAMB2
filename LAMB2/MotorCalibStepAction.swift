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
    let backlashHigh: DeadbandStepCounterAction
    let backlashLow: DeadbandStepCounterAction
    
    init(motor: Int, device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction, range: Int) {
        
        stepHigh = StepDisplacementAction(motor: motor, dir: StageConstants.DIR_HIGH, steps: range, device: device, stage: stage, displacer: displacer)
        stepLow = StepDisplacementAction(motor: motor, dir: StageConstants.DIR_LOW, steps: range, device: device, stage: stage, displacer: displacer)
        
        backlashHigh = DeadbandStepCounterAction(motor: motor, dir: StageConstants.DIR_HIGH, device: device, stage: stage, displacer: displacer)
        backlashLow = DeadbandStepCounterAction(motor: motor, dir: StageConstants.DIR_LOW, device: device, stage: stage, displacer: displacer)
        
        super.init([backlashHigh, backlashLow, stepLow, backlashHigh, stepHigh])
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