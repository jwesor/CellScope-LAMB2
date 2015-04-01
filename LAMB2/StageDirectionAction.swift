
//
//  StageDirectionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageDirectionAction : DeviceAction {
    
    init(_ device: DeviceConnector, motor: Int, dir: Bool) {
        let dirCode = StageDirectionAction.getDirectionCode(motor, dir: dir)
        super.init(device, id: "stage_direction", data: [dirCode, 0x0, 0x0])
    }
    
    class func getDirectionCode(motor: Int, dir: Bool) -> Byte {
        var dirCode: Byte = 0
        switch motor {
        case StageConstants.MOTOR_1:
            dirCode = (dir ? 0x13 : 0x03)
            break
        case StageConstants.MOTOR_2:
            dirCode = (dir ? 0x17 : 0x07)
            break
        case StageConstants.MOTOR_3:
            dirCode = (dir ? 0x09 : 0x08)
            break
        default:
            break
        }
        return dirCode
    }
    
}