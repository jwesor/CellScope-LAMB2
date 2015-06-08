//
//  MotorStepCalibratorAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorStepCalibratorAction : SequenceAction, ActionCompletionDelegate {
    
    let displace: IPDisplacement
    let displaceAction: ImageProcessorAction
    let awayAction: StageEnableStepAction
    let returnAction: StageEnableStepAction
    let steps: Int
    let camera: CameraSession
    var phase: Int
    
    init(_ motor: Int, device: DeviceConnector, camera: CameraSession, stage: StageState, range: UInt = 5) {
        displace = IPDisplacement()
        displace.croppingEnabled = true
        displaceAction = ImageProcessorAction([displace], standby: 1, camera: camera)
        awayAction = StageEnableStepAction(device, motor: motor, dir: StageConstants.DIR_HIGH, steps: range, stage: stage)
        returnAction = StageEnableStepAction(device, motor: motor, dir: StageConstants.DIR_LOW, steps: range, stage: stage)
        steps = Int(range)
        self.camera = camera
        phase = 0
        super.init([awayAction, displaceAction, awayAction, displaceAction, returnAction, displaceAction, returnAction])
        displaceAction.addCompletionDelegate(self)
        camera.addAsyncImageProcessor(displaceAction.proc)
    }
    
    override func doExecution() {
//        camera.addAsyncImageProcessor(displaceAction.proc)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        //phase 0: get initial position
        //phase 1: get displacement without backlash
        //phase 2: get displacement with backlash
        if (phase == 1) {
            print("\(displace.dX), \(displace.dY)")
        } else if (phase == 2) {
            print("\(displace.dX), \(displace.dY)")
        }
        phase += 1
    }
    
    override func cleanup() {
        phase = 0
//        camera.removeImageprocessor(displaceAction.proc)
    }
}