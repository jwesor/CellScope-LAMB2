//
//  MFCMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCMoveAction : SequenceAction {
    
    init(_ mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1) {
        super.init()
        let stage = mfc.stage
        
        let a = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_HIGH)
        let b = stage.getStep(StageConstants.MOTOR_1, dir: StageConstants.DIR_LOW)
        let c = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_HIGH)
        let d = stage.getStep(StageConstants.MOTOR_2, dir: StageConstants.DIR_LOW)
        
        // Figure out which combination of motors/directions to step that will
        // minimize required number of steps and bring us to the target location
        // as close as possible.
        // A = steps of motor a, B = steps of motor b, etc.
        let (A1, C1) = calculateSteps(p: a, q: c, X: x, Y: y)
        let (B1, D1) = calculateSteps(p: b, q: d, X: x, Y: y)
        let (A2, D2) = calculateSteps(p: a, q: d, X: x, Y: y)
        let (B2, C2) = calculateSteps(p: b, q: c, X: x, Y: y)
        let A1C1 = (A1 < 0 || C1 < 0) ? Int.max : A1 + C1
        let B1D1 = (B1 < 0 || D1 < 0) ? Int.max : B1 + D1
        let A2D2 = (A2 < 0 || D2 < 0) ? Int.max : A2 + D2
        let B2C2 = (B2 < 0 || C2 < 0) ? Int.max : B2 + C2
        
        var steps1:Int = 0
        var steps2:Int = 0
        var dir1: Bool = StageConstants.DIR_HIGH
        var dir2: Bool = StageConstants.DIR_HIGH
        let minSteps = min(A1C1, B1D1, A2D2, B2C2)
        if minSteps != Int.max {
            if minSteps == A1C1 {
                steps1 = A1
                steps2 = C1
                dir1 = StageConstants.DIR_HIGH
                dir2 = StageConstants.DIR_HIGH
            } else if minSteps == B1D1 {
                steps1 = B1
                steps2 = D1
                dir1 = StageConstants.DIR_LOW
                dir2 = StageConstants.DIR_LOW
            } else if minSteps == A2D2 {
                steps1 = A2
                steps2 = D2
                dir1 = StageConstants.DIR_HIGH
                dir2 = StageConstants.DIR_LOW
            } else { // B2C2
                steps1 = B2
                steps2 = C2
                dir1 = StageConstants.DIR_LOW
                dir2 = StageConstants.DIR_HIGH
            }
        }
        
        // For each motor: enable motor, set direction, move in small strides not exceeding
        // half a field of vision. Use the displacer to update the MFC position with every
        // stride until the desired number of steps is reached. Finally, disable the motor.
        if steps1 != 0 {
            let dir1Action = MFCDirectionAction(mfc, motor: StageConstants.MOTOR_1, dir: dir1)
            addSubAction(mfc.enable1)
            addSubAction(mfc.displacer)
            addSubAction(dir1Action)
            let stride1Action = StageStepAction(mfc.device, motor: StageConstants.MOTOR_1, steps: stride)
            var remaining: UInt = UInt(steps1)
            while remaining >= UInt(stride) {
                addSubAction(stride1Action)
                addSubAction(mfc.displacer)
                remaining -= UInt(stride)
            }
            if remaining >= 0 {
                addSubAction(StageStepAction(mfc.device, motor: StageConstants.MOTOR_1, steps: UInt8(remaining)))
                addSubAction(mfc.displacer)
            }
            addSubAction(mfc.disable1)
        }
        if steps2 != 0 {
            let dir2Action = MFCDirectionAction(mfc, motor: StageConstants.MOTOR_2, dir: dir2)
            addSubAction(mfc.enable2)
            addSubAction(mfc.displacer)
            addSubAction(dir2Action)
            let stride2Action = StageStepAction(mfc.device, motor: StageConstants.MOTOR_2, steps: stride)
            var remaining: UInt = UInt(steps2)
            while remaining >= UInt(stride) {
                addSubAction(stride2Action)
                addSubAction(mfc.displacer)
                remaining -= UInt(stride)
            }
            if remaining >= 0 {
                addSubAction(StageStepAction(mfc.device, motor: StageConstants.MOTOR_2, steps: UInt8(remaining)))
                addSubAction(mfc.displacer)
            }
            addSubAction(mfc.disable2)
        }
        
        //TODO: Increase cross correlation accuracy. Background subtraction?
    }
    
    private func calculateSteps(#p: (x: Int, y: Int), q: (x: Int, y: Int), X: Int, Y: Int) -> (Int, Int) {
        let s = p.x, t = p.y, u = q.x, v = q.y;
        let P = Float(v * X - u * Y) / Float(s * v - t * u)
        let Q = Float(t * X - s * Y) / Float(t * u - s * v)
        return (Int(round(P)), Int(round(Q)))
    }
    
}