//
//  StepDisplacementAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StepDisplacementAction: SequenceAction, ActionCompletionDelegate {
    
    let displacer: ImgDisplacementAction
    let stepAction: StageStepAction
    let stride: Int
    let targetSteps: Int
    private var stepCounter: Int = 0
    private(set) var dX: [Int] = []
    private(set) var dY: [Int] = []
    private(set) var aveX: Float = 0
    private(set) var aveY: Float = 0
    
    init(motor: Int, steps: Int, stride: UInt8 = 1, device: DeviceConnector, stage: StageState, displacer: ImgDisplacementAction) {
        stepAction = StageStepAction(device, motor: motor, steps: stride)
        self.displacer = displacer
        targetSteps = steps
        self.stride = Int(stride)
        super.init()
        addSubAction(displacer)
        for var i = 0; i < steps; i += self.stride {
            addSubAction(stepAction)
            addSubAction(displacer)
        }
    }
    
    override func doExecution() {
        dX = []
        dY = []
        stepCounter = 0
        displacer.addCompletionDelegate(self)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (stepCounter > 0) {
            dX.append(Int(displacer.dX))
            dY.append(Int(displacer.dY))
        }
        print("\(dX) \(dY)")
        stepCounter += stride
    }
    
    override func cleanup() {
        aveX = getAveX()
        aveY = getAveY()
        displacer.removeCompletionDelegate(self)
        super.cleanup()
    }
    
    private func getAveX() -> Float {
        var sum: Float = 0
        for x in dX {
            sum += Float(x)
        }
        if dX.count == 0 {
            return 0
        }
        return sum / Float(dX.count)
    }
    
    private func getAveY() -> Float {
        var sum: Float = 0
        for y in dY {
            sum += Float(y)
        }
        if dY.count == 0 {
            return 0
        }
        return sum / Float(dY.count)
    }
}