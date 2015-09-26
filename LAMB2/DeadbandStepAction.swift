//
//  Moves the motor  one stride at a time until movement is detected.
//
//  DeadbandStepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/25/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class DeadbandStepAction: SequenceAction, ActionCompletionDelegate {
    
    let displacer: ImgDisplacementAction
    let stepAction: StageStepAction
    private let stride: Int
    private let limit: Int
    private let threshold: Int
    private(set) var stepCount: Int = 0
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0
    
    init(motor: Int, device: DeviceConnector, displacer: ImgDisplacementAction, stride: UInt8 = 1, motionThreshold: Int = 5, strideLimit: Int = 50) {
        stepAction = StageStepAction(device, motor: motor, steps: stride)
        self.displacer = displacer
        self.threshold = motionThreshold
        self.limit = strideLimit
        self.stride = Int(stride)
        
        super.init([displacer])
    }
    
    override func doExecution() {
        stepCount = -1
        displacer.addCompletionDelegate(self)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        let motion = sqrt(Float(displacer.dX * displacer.dX + displacer.dY * displacer.dY))
        if (stepCount == -1) {
            stepCount = 0
            addOneTimeAction(stepAction)
            addOneTimeAction(displacer)
        } else if motion < Float(threshold) && stepCount / stride < limit {
            stepCount += stride
            addOneTimeAction(stepAction)
            addOneTimeAction(displacer)
        } else {
            dX = displacer.dX
            dY = displacer.dY
        }
    }
    
    override func cleanup() {
        displacer.removeCompletionDelegate(self)
        super.cleanup()
    }
}