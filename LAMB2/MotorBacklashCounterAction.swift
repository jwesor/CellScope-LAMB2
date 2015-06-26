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
    let stepAction: StageEnableStepAction
    let camera: CameraSession
    var backlashStepCounter: Int
    var firstDisplace: Int
    var partialStepX: Int
    var partialStepY: Int
    let MOTION_THRESHOLD: Int = 5

    init(_ motor: Int, dir: Bool, device: DeviceConnector, camera: CameraSession, stage: StageState) {
        displace = IPDisplacement()
        displaceAction = ImageProcessorAction([displace], standby: 3, camera: camera)
        stepAction = StageEnableStepAction(device, motor: motor, dir: dir, steps: 1, stage: stage)
        backlashStepCounter = 0
        firstDisplace = 0
        partialStepX = 0
        partialStepY = 0
        self.camera = camera
        super.init()
        displaceAction.addCompletionDelegate(self)
    }
    
    override func doExecution() {
        camera.addAsyncImageProcessor(displaceAction.proc)
        backlashStepCounter = 0
        firstDisplace = 0
        addSubAction(displaceAction)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        print("displacement check\n")
        if (firstDisplace > 5) {
            print("\(displace.dX), \(displace.dY)\n")
            let dX: Int = Int(displace.dX)
            let dY: Int = Int(displace.dY)
            if (abs(dX) <= MOTION_THRESHOLD && abs(dY) <= MOTION_THRESHOLD) {
                backlashStepCounter += 1
                addSubAction(stepAction)
                addSubAction(displaceAction)
                print("Not done!\n")
            } else {
                partialStepX = dX
                partialStepY = dY
                print("Done\n")
            }
        } else {
            firstDisplace += 1
            addSubAction(displaceAction)
        }
    }
    
    override func cleanup() {
        print("Finished!")
        camera.removeImageProcessor(displaceAction.proc)
    }
}