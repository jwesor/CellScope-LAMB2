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
    
    init(_ dc: DeviceConnector, motor: Int, dir: Bool, steps: Int, stage: StageState) {
        super.init()
        addSubAction(StageDirectionAction(dc, motor: motor, dir: dir, stage: stage))
        addSubAction(StageEnableAction(dc, motor: motor, stage: stage))
        addSubAction(StageMoveAction(dc, motor: motor, steps: steps))
        addSubAction(StageDisableAction(dc, motor: motor, stage: stage))
    }
    
}