//  Moves the motor in the given direction one stride at a time
//  until movement is detected. Counts the number of steps
//  taken to do so.
//
//  DeadbandStepCounterAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class DeadbandStepCounterAction: SequenceAction, ActionCompletionDelegate {
    
    let dirAction: StageDirectionAction
    let enableAction: StageEnableAction
    let displacer: ImgDisplacementAction
    let stepAction: StageStepAction
    let disableAction: StageDisableAction
    private let stride: Int
    private let limit: Int
    private let threshold: Int
    private(set) var stepCount: Int = 0
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0
    
    init(motor: Int, dir: Bool, device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction, stride: UInt8 = 1, motionThreshold: Int = 5, strideLimit: Int = 50) {
        
        dirAction = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
        enableAction = StageEnableAction(device, motor: motor, stage: stage)
        disableAction = StageDisableAction(device, motor: motor, stage: stage)
        stepAction = StageStepAction(device, motor: motor, steps: stride)
        self.displacer = displacer
        self.threshold = motionThreshold
        self.limit = strideLimit
        self.stride = Int(stride)
        
        super.init([dirAction, enableAction, displacer])
    }
    
    override func doExecution() {
        stepCount = -1
        displacer.addOneTimeCompletionDelegate(self)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        let motion = sqrt(Float(displacer.dX * displacer.dX + displacer.dY * displacer.dY))
        if (stepCount == -1) {
            stepCount = 0
            addOneTimeAction(stepAction)
            addOneTimeAction(displacer)
            displacer.addOneTimeCompletionDelegate(self)
        } else if motion < Float(threshold) && stepCount / stride < limit {
            stepCount += stride
            addOneTimeAction(stepAction)
            addOneTimeAction(displacer)
            displacer.addOneTimeCompletionDelegate(self)
        } else {
            dX = displacer.dX
            dY = displacer.dY
        }
    }
}