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
    private var steps1: Bool = 0
    private var steps2: Bool = 0

    let pre: MFCPreMoveAction
    let intra: MFCIntraMoveAction
    let psot: MFCPostMoveAction
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1) {
        super.init()

        let stage = mfc.stage
        let a = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH)
        let b = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW)
        let c = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH)
        let d = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW)

        let (A1, C1) = calculateSteps(p: a, q: c, X: x, Y: y)
        let (B1, D1) = calculateSteps(p: b, q: d, X: x, Y: y)
        let (A2, D2) = calculateSteps(p: a, q: d, X: x, Y: y)
        let (B2, C2) = calculateSteps(p: b, q: c, X: x, Y: y)
        let predicted = [
            (A1 + C1): (DIR_HIGH, A1, DIR_HIGH, C1),
            (B1 + D1): (DIR_LOW, B1, DIR_LOW, D1),
            (A2 + D2): (DIR_HIGH, A1, DIR_LOW, D2),
            (B2 + C2): (DIR_LOW, B2, DIR_HIGH, C2)
        ]
        let minSteps = min(A1+C1, B1+D1, A2+D2, B2+C2)
        if minSteps != Float.max {
            dir1, steps1, dir2, steps2 = predicted[minSteps]
            var motorDirs[Int:Bool] = []
            var motorSteps[Int:Float] = []
            if round(steps1) > 0 {
                motorDirs[StageConstants.MOTOR_1] = dir1
                motorSteps[StageConstants.MOTOR_1] = steps1
            }
            if round(steps2) > 0 {
                motorDirs[StageConstants.MOTOR_2] = dir2
                motorSteps[StageConstants.MOTOR_2]  = steps2
            }
            pre = MFCPreMoveAction(mfc: mfc, motorDirs: motorDirs)
            intra = MFCIntraMoveAction(mfc: mfc, motorSteps: motorSteps, stride: stride)
            post = MFCPostMoveAction(mfc: mfc, motors: Array(motorDirs.keys))
            addSubActions([pre, intra, post])
            pre.addCompletionDelegate(self)
        } else {
            pre = MFCPreMoveAction(mfc: mfc, motorDirs: [])
            intra = MFCIntraMoveAction(mfc: mfc, motorSteps: [])
            post = MFCPostMoveAction(mfc: mfc: motors: [])
        }
    }

    class func calculateSteps(p p: (x: Int, y: Int), q: (x: Int, y: Int), X: Int, Y: Int) -> (Float, Float) {
        let s = p.x, t = p.y, u = q.x, v = q.y;
        let P = Float(v * X - u * Y) / Float(s * v - t * u)
        let Q = Float(t * X - s * Y) / Float(t * u - s * v)
        if (s * v - t * u) == 0 || (t * u - s * v) == 0 {
            return (Float.max, Float.max)
        }
        return (P, Q)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === pre {

        }
    }
}