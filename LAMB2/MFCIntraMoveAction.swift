//
//  MFCIntraMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCIntraMoveAction : SequenceAction, ActionCompletionDelegate {

    let displacer: MFCDisplacementAction
    let maxStepDist: Float
    let tolerance: Float
    let microstep: Bool
    let stride: UInt8
    let x: Int, y: Int
    private var tX: Int = 0, tY: Int = 0
    private var dX: Int = 0, dY: Int = 0
    
    init(displacer: MFCDisplacementAction, x: Int, y: Int, stride: UInt8, microstep: Bool = true) {
        let mfc = displacer.mfc
        self.x = x
        self.y = y
        self.displacer = displacer
        self.microstep = microstep

        maxStepDist =  MFCMoveAction.getMaxStepDist(mfc.stage, microstep: microstep)
        if (stride == 0) {
            let (width, height) = mfc.stage.getFovDimens()
            let diameter = Float(min(width, height)) / 8
            self.stride = UInt8(max(Float(1), min(Float(UInt8.max), diameter/maxStepDist)))
        } else {
            self.stride = stride
        }
        tX = x
        tY = y
        tolerance = maxStepDist * 1.5
        super.init([displacer])
    }
    
    func setAdjustment(adjX adjX: Int, adjY: Int) {
        tX = x + adjX
        tY = y + adjY
    }
    
    override func doExecution() {
        dX = 0
        dY = 0
        displacer.addCompletionDelegate(self)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === displacer {
            dX += displacer.dX
            dY += displacer.dY
            print("\((dX, dY)) \((tX, tY))")
            let distToTarget = sqrt(Float((tX - dX) * (tX - dX) + (tY - dY) * (tY - dY)))
            if distToTarget > tolerance && distToTarget > maxStepDist {
                let stridesRemaining = UInt8(min(Float(UInt8.max), distToTarget / maxStepDist))
                let stepsPerStride = min(self.stride, stridesRemaining)
                let moveAction = MFCIntraMoveStepAction(mfc: displacer.mfc, x: tX - dX, y: tY - dY, steps: stepsPerStride, microstep: microstep)
                addOneTimeActions([moveAction, displacer])
            }
        }
    }
    
    override func cleanup() {
        displacer.removeCompletionDelegate(self)
    }
}