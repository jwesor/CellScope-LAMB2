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
    var microstepping: Bool = false
    var fov: (x: Int32, y: Int32, width: Int32, height: Int32) = (0, 0, 0, 0)

    func isMatchingEnable(motor: Int, state: Bool) -> Bool {
        return motors[motor]?.en == states[state]
    }
    
    func isMatchingDirection(motor: Int, state: Bool) -> Bool {
        return motors[motor]?.dir == states[state]
    }
    
    func isUnknownEnable(motor: Int) -> Bool {
        return motors[motor]?.en == StageMotorState.UNKNOWN
    }
    
    func getBacklash(motor: Int, dir: Bool, microstep: Bool = false) -> Int {
        if !microstep {
            return motors[motor]!.backlash[dir]!
        } else {
            return motors[motor]!.microbacklash[dir]!
        }
    }
    
    func setBacklash(val: Int, motor: Int, dir: Bool, microstep: Bool = false) {
        if !microstep {
            motors[motor]?.backlash[dir] = val
        } else {
            motors[motor]?.microbacklash[dir] = val
        }
    }
    
    func getStep(motor: Int, dir: Bool, microstep: Bool = false) -> (x: Int, y: Int) {
        if !microstep {
            return motors[motor]!.step[dir]!
        } else {
            return motors[motor]!.microstep[dir]!
        }
    }
    
    func setStep(val: (x: Int, y: Int), motor: Int, dir: Bool, microstep: Bool = false) {
        if !microstep {
            motors[motor]?.step[dir] = val
        } else {
            motors[motor]?.microstep[dir] = val
        }
    }
    
    func resetAll() {
        for (_, state) in motors {
            state.reset()
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
    
    func setFovBounds(x: Int32, y: Int32, width: Int32, height: Int32) {
        fov.x = x
        fov.y = y
        fov.width = width
        fov.height = height
    }
    
    func isFovBounded() -> Bool {
        return fov.width != 0 && fov.height != 0
    }
    
    func setImageProcessorRoiToFov(ip: ImageProcessor) {
        ip.roiX = fov.x
        ip.roiY = fov.y
        ip.roiWidth = fov.width
        ip.roiHeight = fov.height
    }
}

class StageMotorState {
    static let UNKNOWN: Int = 2
    var en: Int = UNKNOWN
    var dir: Int = UNKNOWN
    var backlash: [Bool:Int] = [StageConstants.DIR_HIGH: 0, StageConstants.DIR_LOW: 0]
    var step: [Bool:(x: Int, y: Int)] = [StageConstants.DIR_HIGH: (x: 0, y: 0), StageConstants.DIR_LOW: (x: 0, y: 0)]
    var microbacklash: [Bool:Int] = [StageConstants.DIR_HIGH: 0, StageConstants.DIR_LOW: 0]
    var microstep: [Bool:(x: Int, y: Int)] = [StageConstants.DIR_HIGH: (x: 0, y: 0), StageConstants.DIR_LOW: (x: 0, y: 0)]
    
    func reset() {
        en = StageMotorState.UNKNOWN
        dir = StageMotorState.UNKNOWN
        backlash = [StageConstants.DIR_HIGH: 0, StageConstants.DIR_LOW: 0]
        step = [StageConstants.DIR_HIGH: (x: 0, y: 0), StageConstants.DIR_LOW: (x: 0, y: 0)]
        microbacklash = [StageConstants.DIR_HIGH: 0, StageConstants.DIR_LOW: 0]
        microstep = [StageConstants.DIR_HIGH: (x: 0, y: 0), StageConstants.DIR_LOW: (x: 0, y: 0)]
    }
}