//
//  MFCIntraMoveStepAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/11/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCIntraMoveStepAction: SequenceAction {
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1, microstep: Bool = true) {
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
        let (motor, dir) = bestMove
        let dirAction = mfc.directionAction(motor, dir: dir)
        let stepAction = StageStepAction(mfc.device, motor: motor, steps: stride)
        super.init([dirAction, stepAction])
    }
    
}