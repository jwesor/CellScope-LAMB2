//
//  StageDisableAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageDisableAction : DeviceAction {
    
    class var MOTOR_1: Int { return StageDisableAction.MOTOR_1 }
    class var MOTOR_2: Int { return StageDisableAction.MOTOR_2 }
    class var MOTOR_3: Int { return StageDisableAction.MOTOR_3 }
    
    init(_ device: DeviceConnector, motor: Int) {
        var code = StageDisableAction.getDisableCode(motor)
        super.init(device, id: "stage_disable", data: [code, 0x0, 0x0])
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
    
}