//
//  StageMoveAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/25/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageMoveAction : SequenceAction {
    init(_ dc: DeviceConnector, motor: Int, steps: Int) {
        super.init()
        if steps > 0 {
            // Step at most 255 steps at a time
            var remainingSteps = steps
            let max = Int(UInt8.max)
            let fullStep = StageStepAction(dc, motor: motor, steps: UInt8.max)
            while remainingSteps > 0 {
                if remainingSteps >= max {
                    addSubAction(fullStep)
                    remainingSteps -= max
                } else {
                    addSubAction(StageStepAction(dc, motor: motor, steps: UInt8(remainingSteps)))
                    remainingSteps = 0
                }
            }
        }
    }
}