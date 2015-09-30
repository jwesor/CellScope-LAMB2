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

class DeadbandStepCounterAction: SequenceAction {
    
    let dirAction: StageDirectionAction
    let displacer: ImgDisplacementAction
    let stepAction: DeadbandStepAction
    private let stride: Int
    private(set) var stepCount: Int = 0
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0
    
    init(motor: Int, dir: Bool, device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction, stride: UInt8 = 1) {
        
        dirAction = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
        stepAction = DeadbandStepAction(motor: motor, device: device, displacer: displacer, stride: stride)
        self.displacer = displacer
        self.stride = Int(stride)
        
        super.init([dirAction, stepAction])
    }
    
    override func cleanup() {
        dX = stepAction.dX
        dY = stepAction.dY
        stepCount = stepAction.stepCount
        super.cleanup()
    }
}