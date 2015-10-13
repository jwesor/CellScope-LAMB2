//
//  MFCIntraMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCIntraMoveAction : SequenceAction, ActionCompletionDelegate {

    let mfc: MFCSystem
    let tolerance: Float
    let stride: UInt8
    let x: Int, y: Int
    private var tX: Int = 0, tY: Int = 0
    private var dX: Int = 0, dY: Int = 0
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1, microstep: Bool = true) {
        self.mfc = mfc
        self.x = x
        self.y = y
        self.stride = stride
        tX = x
        tY = y
        let maxStep = MFCMoveAction.getMaxStepDist(mfc.stage, microstep: microstep)
        tolerance = maxStep * 2
        //TODO: Speed up movement by skipping backlash/deadband where possible
        super.init([mfc.displacer])
    }
    
    func setAdjustment(adjX adjX: Int, adjY: Int) {
        tX = x + adjX
        tY = y + adjY
    }
    
    override func doExecution() {
        dX = 0
        dY = 0
        mfc.displacer.addCompletionDelegate(self)
        super.doExecution()
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === mfc.displacer {
            dX += mfc.displacer.dX
            dY += mfc.displacer.dY
            let distToTarget = sqrt(Float((tX - dX) * (tX - dX) + (tY - dY) * (tY - dY)))
            let stridesRemaining = UInt8(distToTarget / tolerance)
            if stridesRemaining >= 1 {
                let stepsPerStride = min(self.stride, stridesRemaining)
                let moveAction = MFCIntraMoveStepAction(mfc: mfc, x: tX - dX, y: tY - dY, stride: stepsPerStride)
                addOneTimeActions([moveAction, mfc.displacer])
            }
        }
    }
    
    override func cleanup() {
        mfc.displacer.removeCompletionDelegate(self)
        super.cleanup()
    }

}