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
    var stepCounter: Int
    let targetSteps: Int
    var dX: [Int]
    var dY: [Int]
    
    init(_ motor: Int, dir: Bool, steps: Int, device: DeviceConnector, camera: CameraSession, stage: StageState) {
        displace = IPDisplacement()
        displaceAction = ImageProcessorAction([displace], standby: 3, camera: camera)
        enableAction = StageEnableAction(device, motor: motor, stage: stage)
        disableAction = StageDisableAction(device, motor: motor, stage: stage)
        dirAction = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
        stepAction = StageStepAction(device, motor: motor, steps: 1, stage: stage)
        dX = []
        dY = []
        displaceCounter = 0
        stepCounter = 0
        targetSteps = steps
        self.camera = camera
        super.init()
        displaceAction.addCompletionDelegate(self)
    }
    
    override func doExecution() {
        camera.addAsyncImageProcessor(displaceAction.proc)
        dX = []
        dY = []
        displaceCounter = 0
        stepCounter = 0
        addSubActions([enableAction, dirAction, displaceAction, stepAction, displaceAction])
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (displaceCounter >= 1) {
            dX.append(Int(displace.dX))
            dY.append(Int(displace.dY))
            stepCounter += 1
            if (stepCounter < targetSteps) {
                addSubAction(stepAction)
                addSubAction(displaceAction)
            } else {
                addSubAction(disableAction)
                print("\(dX) \(dY) \n")
            }
        }
        displaceCounter += 1
    }
    
    override func cleanup() {
        camera.removeImageProcessor(displaceAction.proc)
        clearActions()
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