//
//  MFCIntraMoveStepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/11/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCIntraMoveStepAction: SequenceAction, ActionCompletionDelegate {
    
    let dirAction: StageDirectionAction
    let motor: Int
    let dir: Bool
    let stride: UInt8
    let microstep: Bool
    let mfc: MFCSystem
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1, microstep: Bool = true) {
        self.mfc = mfc
        self.stride = stride
        self.microstep = microstep
        let magA = sqrt(Float(x * x + y * y))
        var bestMove = MFCMoveAction.moves[0]
        var bestSimilarity: Float = -1.0
        for move in MFCMoveAction.moves {
            let (motor, dir) = move
            let (bx, by) = mfc.stage.getStep(motor, dir: dir, microstep: microstep)
            let magB = sqrt(Float(bx * bx + by * by))
            let dotAB: Float = Float(x * bx + y * by)
            let cosSim = Float(dotAB) / (magA * magB)
            if cosSim >= bestSimilarity {
                bestSimilarity = cosSim
                bestMove = move
            }
        }
        (motor, dir) = bestMove
        dirAction = mfc.directionAction(motor, dir: dir)
        super.init([dirAction])
        dirAction.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === dirAction {
            var steps: UInt8
            if dirAction.changed {
                let backlash = mfc.stage.getBacklash(motor, dir: dir, microstep: microstep)
                steps = UInt8(min(backlash/4, Int(UInt8.max)))
            } else {
                steps = stride
            }
            addOneTimeAction(StageStepAction(mfc.device, motor: motor, steps: steps))
        }
    }
    
}