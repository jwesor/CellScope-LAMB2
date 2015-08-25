//
//  StageBacklashAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/25/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageBacklashAction : StageStepAction {
    
    init(_ device: DeviceConnector, motor: Int, steps: UInt8, stage: StageState) {
        var stepCode = StageStepAction.getStepCode(motor)
        super.init(device, id: "stage_step", data: [stepCode, steps, 0x0])
    }
    
}