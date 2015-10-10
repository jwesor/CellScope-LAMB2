//
//  MFCMoveMotorStepAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCMoveMotorStepAction : SequenceAction, ActionCompletionDelegate {

    let mfc: MFCSystem
    let stepAction: StageStepAction
    private let totalX: Float
    private let totalY: Float
    private let totalDist: Float
    private let tolerance: Float
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0

    init(mfc: MFCSystem, motor: Int, steps: Float, stride: UInt8 = 1) {
        self.mfc = mfc
        let dir = mfc.stage.isMatchingDirection(motor, state: StageConstants.DIR_HIGH) ? StageConstants.DIR_HIGH : StageConstants.DIR_LOW
        let (stepX, stepY) = mfc.stage.getStep(motor, dir: dir, microstep: true)
        totalX = Float(stepX) * steps
        totalY = Float(stepY) * steps
        totalDist = sqrt(totalX * totalX + totalY * totalY)
        stepAction = StageStepAction(mfc.device, motor: motor, steps: stride)
        tolerance = Float(stride) / steps * 0.5
        super.init([mfc.displacer])
    }

    override func doExecution() {
        mfc.displacer.addCompletionDelegate(self)
        dX = 0
        dY = 0
        super.doExecution()
    }

    func onActionCompleted(action: AbstractAction) {
        if action === mfc.displacer  {
            dX += mfc.displacer.dX
            dY += mfc.displacer.dY
            print("Move \(sqrt(Float(dX * dX + dY * dY))) \((1 - tolerance) * totalDist)")
            if sqrt(Float(dX * dX + dY * dY)) < (totalDist * (1 - tolerance)){
                addOneTimeAction(stepAction)
                addOneTimeAction(mfc.displacer)
            }
        }
    }

    override func cleanup() {
        mfc.displacer.removeCompletionDelegate(self)
        super.cleanup()
    }
}