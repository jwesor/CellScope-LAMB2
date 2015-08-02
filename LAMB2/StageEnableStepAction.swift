//
//  StageEnableStepAction.swift
//  LAMB2
//
//  SequenceAction that instructs the stage to set the direction
//  pin, enable the motor, step for the specified number of steps,
//  and disable the motor.
//
//  Created by Fletcher Lab Mac Mini on 2/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageEnableStepAction: SequenceAction {
    
    let stage: StageState
    
    init(_ dc: DeviceConnector, motor: Int, dir: Bool, steps: Int, stage: StageState, backlashCorrection: Bool = true, toggleEnable: Bool = true) {
        self.stage = stage
        
        super.init()
        addSubAction(StageDirectionAction(dc, motor: motor, dir: dir, stage: stage))
        
        if (toggleEnable) {
            addSubAction(StageEnableAction(dc, motor: motor, stage: stage))
        }
        
        // Step at most 255 steps at a time
        var remainingSteps = steps
        if (backlashCorrection && !stage.isMatchingDirection(motor, state: dir)) {
            remainingSteps += stage.getBacklash(motor, dir: dir)
        }
        let max = Int(UInt8.max)
        let fullStep = StageStepAction(dc, motor: motor, steps: UInt8.max, stage: stage)
        while remainingSteps > 0 {
            if remainingSteps >= max {
                addSubAction(fullStep)
                remainingSteps -= max
            } else {
                addSubAction(StageStepAction(dc, motor: motor, steps: UInt8(remainingSteps), stage: stage))
                remainingSteps = 0
            }
        }
        
        if (toggleEnable) {
            addSubAction(StageDisableAction(dc, motor: motor, stage: stage))
        }
    }
    
}