//
//  MFCMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCMoveAction : SequenceAction, ActionCompletionDelegate {

    private var dir1: Bool = false
    private var dir2: Bool = false
    private var steps1: Float = 0
    private var steps2: Float = 0

    let mfc: MFCSystem
    let dX: Int
    let dY: Int
    let pre: MFCPreMoveAction
    let intra: MFCIntraMoveAction
    let post: MFCPostMoveAction

    let displacer: MFCDisplacementAction
    
    static let moves: [(Int, Bool)] = [
        (StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH),
        (StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW),
        (StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH),
        (StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW)
    ]
    
    init(mfc: MFCSystem, dX: Int, dY: Int, stride: UInt8 = 0) {
        self.mfc = mfc
        self.dX = dX
        self.dY = dY
        displacer = MFCDisplacementAction(mfc: mfc, updateMfc: true)
        pre = MFCPreMoveAction(displacer: displacer, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        intra = MFCIntraMoveAction(displacer: displacer, x: dX, y: dY, stride: stride, microstep: true)
        post = MFCPostMoveAction(displacer: displacer, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        super.init([pre, intra, post])
        pre.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === pre {
            intra.setAdjustment(adjX: -pre.dX, adjY: -pre.dY)
        }
    }
 
    class func getMaxStepMove(stage: StageState, microstep: Bool) -> (motor: Int, dir: Bool) {
        var maxStep: Float = 0
        var maxMove = MFCMoveAction.moves[0]
        for (motor, dir) in MFCMoveAction.moves {
            let (x, y) = stage.getStep(motor, dir: dir, microstep: microstep)
            let dist = Float(x * x + y * y)
            if dist >= maxStep {
                maxStep = dist
                maxMove = (motor, dir)
            }
        }
        return maxMove
    }
    
    class func getMaxStepDist(stage: StageState, microstep: Bool) -> Float {
        let (motor, dir) = MFCMoveAction.getMaxStepMove(stage, microstep: microstep)
        let (x, y) = stage.getStep(motor, dir: dir, microstep: microstep)
        return sqrt(Float(x * x + y * y))
    }
}