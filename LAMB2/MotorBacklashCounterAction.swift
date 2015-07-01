//
//  MotorBacklashCounterAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/25/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorBacklashCounterAction: SequenceAction, ActionCompletionDelegate {
    
    let displace: IPDisplacement
    let displaceAction: ImageProcessorAction
    let enableAction: StageEnableAction
    let disableAction: StageDisableAction
    let dirAction: StageDirectionAction
    let stepAction: StageStepAction
    let camera: CameraSession
    var backlashStepCounter: Int
    var motionStepCounter: Int
    var displaceCounter: Int
    var partialStepX: Int
    var partialStepY: Int
    let MOTION_THRESHOLD: Int = 5
    let HARD_BACKLASH_CAP: Int = 25

    init(_ motor: Int, dir: Bool, device: DeviceConnector, camera: CameraSession, stage: StageState) {
        displace = IPDisplacement()
        displaceAction = ImageProcessorAction([displace], standby: 3, camera: camera)
        enableAction = StageEnableAction(device, motor: motor, stage: stage)
        disableAction = StageDisableAction(device, motor: motor, stage: stage)
        dirAction = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
        stepAction = StageStepAction(device, motor: motor, steps: 1, stage: stage)
        backlashStepCounter = 0
        motionStepCounter = 0
        displaceCounter = 0
        partialStepX = 0
        partialStepY = 0
        self.camera = camera
        super.init()
        displaceAction.addCompletionDelegate(self)
    }
    
    override func doExecution() {
        camera.addAsyncImageProcessor(displaceAction.proc)
        backlashStepCounter = 0
        displaceCounter = 0
        addSubActions([enableAction, dirAction, displaceAction, stepAction, displaceAction])
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (backlashStepCounter < HARD_BACKLASH_CAP) {
            if (displaceCounter >= 1) {
                let dX: Int = Int(displace.dX)
                let dY: Int = Int(displace.dY)
                if (abs(dX) <= MOTION_THRESHOLD && abs(dY) <= MOTION_THRESHOLD) {
                    motionStepCounter = 0
                    backlashStepCounter += 1
                    addSubAction(stepAction)
                    addSubAction(displaceAction)
                } else {
                    motionStepCounter += 1
                    if (motionStepCounter <= 1) {
                        partialStepX = dX
                        partialStepY = dY
                        addSubAction(stepAction)
                        addSubAction(displaceAction)
                    } else {
                        addSubAction(disableAction)
                        print("Backlash \(partialStepX) \(partialStepY) \(backlashStepCounter)\n")
                    }
                }
            }
            displaceCounter += 1
        }
    }
    
    override func cleanup() {
        camera.removeImageProcessor(displaceAction.proc)
        clearActions()
    }
}