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
    let x: Int
    let y: Int
    let stride: UInt8
    let pre: MFCPreMoveAction
    let post: MFCPostMoveAction
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1) {
        self.mfc = mfc
        self.x = x
        self.y = y
        self.stride = stride
        pre = MFCPreMoveAction(mfc: mfc, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        post = MFCPostMoveAction(mfc: mfc, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        super.init([pre])
        pre.addCompletionDelegate(self)
    }

    class func calculateSteps(p p: (x: Int, y: Int), q: (x: Int, y: Int), X: Int, Y: Int) -> (Float, Float) {
        let s = p.x, t = p.y, u = q.x, v = q.y;
        let P = Float(v * X - u * Y) / Float(s * v - t * u)
        let Q = Float(t * X - s * Y) / Float(t * u - s * v)
        if (s * v - t * u) == 0 || (t * u - s * v) == 0 {
            return (-1, -1)
        }
        return (P, Q)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === pre {
            // TODO: Offset from enabling the motors should added into the step motions
            let intra = calculateMove(x: x - pre.dX, y: y - pre.dY)
            addOneTimeActions([intra, post])
        }
    }
    
    private func calculateMove(x x: Int, y: Int) -> MFCIntraMoveAction {
        print("CALCULATED MOTION \(x) \(y)")
        let stage = mfc.stage
        let a = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH, microstep: true)
        let b = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW, microstep: true)
        let c = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH, microstep: true)
        let d = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW, microstep: true)
        
        let (A1, C1) = MFCMoveAction.calculateSteps(p: a, q: c, X: x, Y: y)
        let (B1, D1) = MFCMoveAction.calculateSteps(p: b, q: d, X: x, Y: y)
        let (A2, D2) = MFCMoveAction.calculateSteps(p: a, q: d, X: x, Y: y)
        let (B2, C2) = MFCMoveAction.calculateSteps(p: b, q: c, X: x, Y: y)
        let A1C1 = (A1 < 0 || C1 < 0) ? Float(Int.max) : (A1 + C1)
        let B1D1 = (B1 < 0 || D1 < 0) ? Float(Int.max) : (B1 + D1)
        let A2D2 = (A2 < 0 || D2 < 0) ? Float(Int.max) : (A2 + D2)
        let B2C2 = (B2 < 0 || C2 < 0) ? Float(Int.max) : (B2 + C2)
        var predicted:[Float: (Bool, Float, Bool, Float)] = [:]
        predicted[A1C1] = (StageConstants.DIR_HIGH, A1, StageConstants.DIR_HIGH, C1)
        predicted[B1D1] = (StageConstants.DIR_LOW, B1, StageConstants.DIR_LOW, D1)
        predicted[A2D2] = (StageConstants.DIR_HIGH, A1, StageConstants.DIR_LOW, D2)
        predicted[B2C2] = (StageConstants.DIR_LOW, B2, StageConstants.DIR_HIGH, C2)
        let minSteps = min(A1C1, B1D1, A2D2, B2C2)
        if minSteps < Float(Int.max) {
            (dir1, steps1, dir2, steps2) = predicted[minSteps]!
            var motorSteps:[Int : (Bool, Float)] = [:]
            if round(steps1) > 0 {
                motorSteps[StageConstants.MOTOR_1] = (dir1, steps1)
            }
            if round(steps2) > 0 {
                motorSteps[StageConstants.MOTOR_2]  = (dir2, steps2)
            }
            return MFCIntraMoveAction(mfc: mfc, motorSteps: motorSteps, stride: stride)
        } else {
            return MFCIntraMoveAction(mfc: mfc, motorSteps: [:])
        }
    }
}