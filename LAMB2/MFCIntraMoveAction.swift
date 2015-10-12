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
    let x: Int, y: Int
    private var tX: Int = 0, tY: Int = 0
    private var dX: Int = 0, dY: Int = 0
    
    static let moves: [(Int, Bool)] = [
        (StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH),
        (StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW),
        (StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH),
        (StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW)
    ]

    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1, microstep: Bool = true) {
        self.mfc = mfc
        self.x = x
        self.y = y
        tX = x
        tY = y
        var maxStep: Float = 0
        for (motor, dir) in MFCIntraMoveAction.moves {
            let (x, y) = mfc.stage.getStep(motor, dir: dir, microstep: microstep)
            maxStep = max(maxStep, Float(x * x + y * y))
        }
        tolerance = sqrt(maxStep) * 2
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
            if distToTarget > tolerance {
                let moveAction = MFCIntraMoveStepAction(mfc: mfc, x: tX - dX, y: tY - dY)
                addOneTimeActions([moveAction, mfc.displacer])
            }
        }
    }

}