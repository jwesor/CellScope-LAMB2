//
//  AutofocuserAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class AutofocuserAction : SequenceAction, ActionCompletionDelegate {
    
    let scanAction: ScanFocusAction
    let stepsPerLevel: UInt
    let totalLevels:UInt
    let device:DeviceConnector

    init(levels: UInt, stepsPerLevel: UInt, camera: CameraSession, device: DeviceConnector) {
        self.stepsPerLevel = stepsPerLevel
        self.device = device
        self.totalLevels = levels
        scanAction = ScanFocusAction(levels: levels, stepsPerLevel: stepsPerLevel, camera: camera, device: device)
        super.init()
        scanAction.addCompletionDelegate(self)
        addSubAction(scanAction)
    }
    
    func onActionCompleted(action: AbstractAction) {
        let level = scanAction.bestFocusLevel
        let stepsToMove = (totalLevels - level) * stepsPerLevel
        let moveAction = StageEngageStepAction(dc: device, motor: StageEngageStepAction.MOTOR_3, dir: StageEngageStepAction.DIR_LOW, steps: stepsToMove)
        NSLog("Autofocus target at level %d", level)
        addSubAction(moveAction)
    }
}