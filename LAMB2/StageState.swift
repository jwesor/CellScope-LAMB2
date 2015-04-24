//
//  StageState.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/23/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageState {
    
    let motors: [Int:StageMotorState] = [StageConstants.MOTOR_1: StageMotorState(),
                                         StageConstants.MOTOR_2: StageMotorState(),
                                         StageConstants.MOTOR_3: StageMotorState()]
    let states: [Bool:Int] = [true: 1, false: 0]
    
    func isMatchingEnable(motor: Int, state: Bool) -> Bool {
        return motors[motor]?.en == states[state]
    }
    
    func isMatchingDirection(motor: Int, state: Bool) -> Bool {
        return motors[motor]?.dir == states[state]
    }
    
    func isUnknownEnable(motor: Int) -> Bool {
        return motors[motor]?.en == StageMotorState.UNKNOWN
    }
    
    func isUknownDirection(motor: Int) -> Bool {
        return motors[motor]?.dir == StageMotorState.UNKNOWN
    }
    
    func resetAll() {
        for (motor, state) in motors {
            state.dir = StageMotorState.UNKNOWN
            state.en = StageMotorState.UNKNOWN
        }
    }
    
    func updateEnable(motor: Int, en: Bool) {
        let m = motors[motor]
        if (m != nil) {
            m!.en = states[en]!
        }
    }
    
    func updateDirection(motor: Int, dir: Bool) {
        let m = motors[motor]
        if (m != nil) {
            m!.dir = states[dir]!
        }
    }
    
    func resetEnable(motor: Int) {
        let m = motors[motor]
        if (m != nil) {
            m!.en = StageMotorState.UNKNOWN
        }
    }
    
    func resetDirection(motor: Int) {
        let m = motors[motor]
        if (m != nil) {
            m!.dir = StageMotorState.UNKNOWN
        }
    }
}

class StageMotorState {
    static let UNKNOWN: Int = 2
    var en: Int = UNKNOWN
    var dir: Int = UNKNOWN
}