//
//  StageEnableAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageEnableAction : DeviceAction {
    
    let stage: StageState
    let motor: Int
    
    init(_ device: DeviceConnector, motor: Int, stage: StageState) {
        self.stage = stage
        self.motor = motor
        let code = StageEnableAction.getEnableCode(motor)
        super.init(device, id: "stage_enable", data: [code, 0x0, 0x0])
    }
    
    class func getEnableCode(motor: Int) -> UInt8 {
        let disCode = StageDisableAction.getDisableCode(motor)
        if (disCode != 0) {
            return disCode | 0x10
        } else {
            return 0x0
        }
    }
    
    override func doExecution() {
        if stage.isMatchingEnable(self.motor, state: true) {
            finish()
        } else {
            super.doExecution()
        }
    }
    
    override func cleanup() {
        super.cleanup()
        if (state != ActionState.TIMED_OUT) {
            stage.updateEnable(self.motor, en: true)
        } else if connected {
            stage.resetEnable(self.motor)
        }
    }
}