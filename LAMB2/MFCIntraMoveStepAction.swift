//
//  Takes the specified number of steps in the motor/direction that
//  is closest to the given x and y
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
    let steps: UInt8
    let microstep: Bool
    let mfc: MFCSystem
    
    init(mfc: MFCSystem, x: Int, y: Int, steps: UInt8, microstep: Bool) {
        self.mfc = mfc
        self.steps = steps
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
        // Determine if setting the stage direction requires skipping backlash
        if action === dirAction {
            var stepsToTake: UInt8
            if dirAction.changed {
                let backlash = mfc.stage.getBacklash(motor, dir: dir, microstep: microstep)
                stepsToTake = UInt8(min(backlash/2 + steps, Int(UInt8.max)))
            } else {
                stepsToTake = self.steps
            }
            addOneTimeAction(StageStepAction(mfc.device, motor: motor, steps: stepsToTake))
        }
    }
    
}