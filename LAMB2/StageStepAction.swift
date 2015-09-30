//
//  StageStepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageStepAction : DeviceAction {
    
    init(_ device: DeviceConnector, motor: Int, steps: UInt8) {
        let stepCode = StageStepAction.getStepCode(motor)
        super.init(device, data: [stepCode, steps, 0x0])
    }
    
    class func getStepCode(motor: Int) -> UInt8 {
        var stepCode:UInt8 = 0
        switch motor {
        case StageConstants.MOTOR_1:
            stepCode = 0x18
            break
        case StageConstants.MOTOR_2:
            stepCode = 0x19
            break
        case StageConstants.MOTOR_3:
            stepCode = 0x20
            break
        default:
            break
        }
        return stepCode
    }
    
}