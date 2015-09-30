//
//  StageDisableAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageDisableAction : DeviceAction {
    
    let stage: StageState
    let motor: Int
    
    init(_ device: DeviceConnector, motor: Int, stage: StageState) {
        self.stage = stage
        self.motor = motor
        let code = StageDisableAction.getDisableCode(motor)
        super.init(device, data: [code, 0x0, 0x0])
    }
    
    class func getDisableCode(motor: Int) -> UInt8 {
        var code: UInt8 = 0x0
        switch motor {
        case StageConstants.MOTOR_1:
            code = 0x04
            break
        case StageConstants.MOTOR_2:
            code = 0x05
            break
        case StageConstants.MOTOR_3:
            code = 0x06
            break
        default:
            break
        }
        return code
    }
    
    override func doExecution() {
        if stage.isMatchingEnable(self.motor, state: false) {
            finish()
        } else {
            super.doExecution()
        }
    }
    
    override func cleanup() {
        super.cleanup()
        if (state != ActionState.TIMED_OUT) {
            stage.updateEnable(self.motor, en: false)
        } else if connected {
            stage.resetEnable(self.motor)
        }
    }
}