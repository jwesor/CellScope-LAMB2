//
//  StageMicrostepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageMicrostepAction : DeviceAction {
    
    let code: UInt8
    let micro: Bool
    let stage: StageState
    
    init(_ device: DeviceConnector, enabled: Bool = true, stage: StageState) {
        micro = enabled
        self.stage = stage
        if !enabled {
            code = 0x21
        } else {
            code = 0x22
        }
        super.init(device, data: [code, 0x0, 0x0])
    }
    
    override func doExecution() {
        if stage.microstepping == micro {
            finish()
        } else {
            super.doExecution()
        }
    }
    
    override func cleanup() {
        super.cleanup()
        if (state != ActionState.TIMED_OUT) {
            stage.microstepping = micro
        }
    }
}