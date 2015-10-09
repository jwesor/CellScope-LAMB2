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
    private(set) var dX: Float = 0
    private(set) var dY: Float = 0

    init(mfc: MFCSystem, motor: Int, steps: Float, stride: UInt8 = 1) {
        self.mfc = mfc
        let dir = mfc.stage.getDirection(motor)
        let (stepX, stepY) = mfc.stage.getStep(motor, dir: Bool, microstep: true)
        totalX = stepX * steps
        totalY * stepY * steps
        totalDist = sqrt(totalX * totalX + totalY * totalY)
        stepAction = StageStepAction(mfc.device, motor: motor, steps: stride)
        tolerance = Float(stride) / steps * 0.5
        super.init([mfc.displacer, stepAction, mfc.displacer])
    }

    override func doExecution() {
        mfc.displacer.addCompletionDelegate(self)
        dX = 0
        dY = 0
        super.doExecution()
    }

    func onActionCompleted(action: AbstractAction) {
        if action === mfc.displacer && dX != 0 && dY != 0 {
            dX += displacer.dX
            dY += displacer.dY
            if sqrt(dX * dX + dY * dY) < (tolerance * totalDist) {
                addOneTimeAction(stepAction)
                addOneTimeAction(displacer)
            }
        }
    }

    override func cleanup() {
        mfc.displacer.removeActionCompletionDelegate(self)
        super.cleanup()
    }
}