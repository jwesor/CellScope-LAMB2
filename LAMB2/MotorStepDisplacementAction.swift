//
//  MotorStepDisplacementAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MotorStepDisplacementAction: SequenceAction, ActionCompletionDelegate {
    
    let displace: IPDisplacement
    let displaceAction: ImageProcessorAction
    let enableAction: StageEnableAction
    let disableAction: StageDisableAction
    let dirAction: StageDirectionAction
    let stepAction: StageStepAction
    let camera: CameraSession
    var displaceCounter: Int
    let targetSteps: Int
    var dX: [Int]
    var dY: [Int]
    
    init(_ motor: Int, dir: Bool, steps: Int, device: DeviceConnector, camera: CameraSession, stage: StageState, ip: IPDisplacement? = nil) {
        if (ip != nil) {
            displace = ip!
        } else {
            displace = IPDisplacement()
        }
        displaceAction = ImageProcessorAction([displace], standby: 1, camera: camera)
        enableAction = StageEnableAction(device, motor: motor, stage: stage)
        disableAction = StageDisableAction(device, motor: motor, stage: stage)
        dirAction = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
        stepAction = StageStepAction(device, motor: motor, steps: 1)
        dX = []
        dY = []
        displaceCounter = 0
        targetSteps = steps
        self.camera = camera
        super.init()
        displaceAction.addCompletionDelegate(self)
        addSubActions([enableAction, dirAction, displaceAction])
        for var i = 0; i < steps; i += 1 {
            addSubAction(stepAction)
            addSubAction(displaceAction)
        }
        addSubAction(disableAction)
    }
    
    override func doExecution() {
        dX = []
        dY = []
        displaceCounter = 0
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (displaceCounter >= 1) {
            dX.append(Int(displace.dX))
            dY.append(Int(displace.dY))
        }
        displaceCounter += 1
    }
    
    override func cleanup() {
        print("\(dX) \(dY) \n")
        super.cleanup()
    }
    
    func getAveX() -> Float {
        var sum: Float = 0
        for x in dX {
            sum += Float(x)
        }
        return sum / Float(dX.count)
    }
    
    func getAveY() -> Float {
        var sum: Float = 0
        for y in dY {
            sum += Float(y)
        }
        return sum / Float(dY.count)
    }
}