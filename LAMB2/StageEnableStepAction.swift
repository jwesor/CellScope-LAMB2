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
    
    init(_ dc: DeviceConnector, motor: Int, dir: Bool, steps: UInt) {
        super.init()
        
        addSubAction(StageDirectionAction(dc, motor: motor, dir: dir))
        addSubAction(StageEnableAction(dc, motor: motor))
        
        // Step at most 255 steps at a time
        var remainingSteps = steps
        let max = UInt(UInt8.max)
        while remainingSteps > 0 {
            if remainingSteps >= max {
                addSubAction(StageStepAction(dc, motor: motor, steps: UInt8.max))
                remainingSteps -= max
            } else {
                addSubAction(StageStepAction(dc, motor: motor, steps: UInt8(remainingSteps)))
                remainingSteps = 0
            }
        }
        addSubAction(StageDisableAction(dc, motor: motor))
        
    }
    
}