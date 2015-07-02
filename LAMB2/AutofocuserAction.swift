//
//  AutofocuserAction.swift
//  LAMB2
//
//  Try to reuse this instead of creating new instances.
//  Each new instance attaches a new image processor
//  to the camera.
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class AutofocuserAction : SequenceAction, ActionCompletionDelegate {
    
    let scanAction: ScanFocusAction
    let antiBacklashAction: StageEnableStepAction
    let returnToStartAction: StageEnableStepAction
    let stepsPerLevel: UInt
    let totalLevels: UInt
    let device: DeviceConnector
    let stage: StageState

    init(startLevel: Int, endLevel: Int, stepsPerLvl: UInt8, camera: CameraSession, device: DeviceConnector, stage: StageState) {
        self.stepsPerLevel = UInt(stepsPerLvl)
        self.device = device
        self.stage = stage
        self.totalLevels = UInt(abs(endLevel - startLevel))
        
        returnToStartAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: !ScanFocusAction.SCAN_DIR, steps:totalLevels * stepsPerLevel, stage: stage)
        scanAction = ScanFocusAction(levels: totalLevels, stepsPerLevel: stepsPerLvl, camera: camera, device: device, stage: stage)
        // Move against the direction of scan to match final move
        antiBacklashAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: ScanFocusAction.SCAN_DIR, steps: stepsPerLevel, stage: stage)
        super.init()
        
        if (startLevel != 0) {
            let initialMove = UInt(abs(startLevel)) * stepsPerLevel
            let dir = (startLevel < 0) ? StageConstants.DIR_LOW : StageConstants.DIR_HIGH
            let moveToStartAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: dir, steps: initialMove, stage: stage)
            addSubAction(moveToStartAction)
        }
        addSubAction(antiBacklashAction)
        addSubAction(scanAction)
        
        addSubAction(returnToStartAction)
        returnToStartAction.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        let stepsToMove = scanAction.bestFocusLevel * stepsPerLevel
        let moveAction = StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: ScanFocusAction.SCAN_DIR, steps: stepsToMove, stage: stage)
        addOneTimeAction(moveAction)
        println("autofocus complete!")
    }
}