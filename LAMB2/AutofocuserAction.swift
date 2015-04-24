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
    let totalLevels: UInt
    let device: DeviceConnector
    let stage: StageState

    init(startLevel: Int, endLevel: Int, stepsPerLevel: UInt, camera: CameraSession, device: DeviceConnector, stage: StageState) {
        self.stepsPerLevel = stepsPerLevel
        self.device = device
        self.stage = stage
        self.totalLevels = UInt(abs(endLevel - startLevel))
        scanAction = ScanFocusAction(levels: totalLevels, stepsPerLevel: stepsPerLevel, camera: camera, device: device, stage: stage)
        super.init()
        let initialMove = min(startLevel, endLevel)
        if (initialMove != 0) {
            let dir = (initialMove < 0) ? StageConstants.DIR_LOW : StageConstants.DIR_HIGH
            let moveToStartAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: dir, steps: UInt(abs(initialMove)), stage: stage)
            addSubAction(moveToStartAction)
        }
        addSubAction(scanAction)
        scanAction.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        let level = scanAction.bestFocusLevel
        let stepsToMove = (totalLevels - level) * stepsPerLevel
        let moveAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: StageConstants.DIR_LOW, steps: stepsToMove, stage: stage)
        addSubAction(moveAction)
        println("autofocus complete!")
    }
}