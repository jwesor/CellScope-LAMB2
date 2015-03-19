//
//  StageEngageStepAction.swift
//  LAMB2
//
//  SequenceAction that instructs the stage to set the direction
//  pin, engage the motor, step for the specified number of steps,
//  and disengage the motor.
//
//  Created by Fletcher Lab Mac Mini on 2/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageEngageStepAction: SequenceAction {
    
    class var DIR_LOW: Bool { return true }
    class var DIR_HIGH: Bool { return false }
    class var MOTOR_1: Int { return 1 }
    class var MOTOR_2: Int { return 2 }
    class var MOTOR_3: Int { return 3 }
    
    init(dc: DeviceConnector, motor: Int, dir: Bool, steps: UInt) {
        super.init()
        
        var dirCode:Byte = 0;
        if (motor == StageEngageStepAction.MOTOR_3) {
        }
        var enCode:Byte = 0x0
        var stepCode:Byte = 0x0
        
        switch motor {
        case StageEngageStepAction.MOTOR_1:
            enCode = 0x04
            stepCode = 0x18
            dirCode = (dir ? 0x17 : 0x07)
            break
        case StageEngageStepAction.MOTOR_2:
            enCode = 0x05
            stepCode = 0x19
            dirCode = (dir ? 0x13 : 0x03)
            break
        case StageEngageStepAction.MOTOR_3:
            enCode = 0x06
            stepCode = 0x20
            dirCode = (dir ? 0x09 : 0x08)
            break
        default:
            break
        }
        
        if enCode != 0x0 {
            // Set the direction pin
            addSubAction(DeviceAction(dc: dc, id: "stage_direction", data: [dirCode, 0x0, 0x0]))
            // Engage the motor (EN_# LOW)
            addSubAction(DeviceAction(dc: dc, id: "stage_engage", data: [enCode | 0x10, 0x0, 0x0]))
            
            // Step (STEP_PIN_#)
            var remainingSteps = steps
            let max = UInt(UInt8.max)
            while remainingSteps > 0 {
                if remainingSteps >= max {
                    addSubAction(DeviceAction(dc: dc, id: "stage_step", data: [stepCode, UInt8.max, 0x0]))
                    remainingSteps -= max
                } else {
                    addSubAction(DeviceAction(dc: dc, id: "stage_step", data: [stepCode, UInt8(remainingSteps), 0x0]))
                    remainingSteps = 0
                }
            }
            // Disengage the motor (EN_# HIGH)
            addSubAction(DeviceAction(dc: dc, id: "stage_disengage", data: [enCode, 0x0, 0x0]))
        }
        
    }
    
}