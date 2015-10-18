//
//  Prepares the MFC for MFCMoveAction. Enables microstepping,
//  sets motor directions, enables the motors, checks for displacements that
//  might have occurred, and eliminates deadband/backlash with DeadbandStepAction
//
//  MFCPreMoveAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/8/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCPreMoveAction : SequenceAction {

    let displacer: MFCDisplacementAction
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0

    init(displacer: MFCDisplacementAction, motors: [Int]) {
        self.displacer = displacer
        super.init()
        let mfc = displacer.mfc
        addSubAction(mfc.microstep)
        addSubAction(displacer)
        for (motor) in motors {
            addSubAction(mfc.motorAction(motor, enable: true))
            addSubAction(displacer)
        }

    }

    override func cleanup() {
        dX = displacer.dX
        dY = displacer.dY
        super.cleanup()
    }
}