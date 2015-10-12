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
    let intra: MFCIntraMoveAction
    let post: MFCPostMoveAction
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1) {
        self.mfc = mfc
        self.x = x
        self.y = y
        self.stride = stride
        pre = MFCPreMoveAction(mfc: mfc, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        intra = MFCIntraMoveAction(mfc: mfc, x: x, y: x, stride: stride)
        post = MFCPostMoveAction(mfc: mfc, motors: [StageConstants.MOTOR_1, StageConstants.MOTOR_2])
        super.init([pre, intra, post])
        pre.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action === pre {
            // TODO: Offset from enabling the motors should added into the step motions
            print("adjust \((pre.dX, pre.dY)))")
            intra.setAdjustment(adjX: pre.dX, adjY: pre.dY)
        }
    }
    
}