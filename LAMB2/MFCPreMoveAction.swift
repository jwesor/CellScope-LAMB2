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

    let mfc: MFCSystem
    private var x: Int = 0
    private var y: Int = 0
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0

    init(mfc: MFCSystem, motorDirs: [Int:Bool]) {
        self.mfc = mfc
        super.init()
        addSubAction(mfc.microstep)
        addSubAction(mfc.displacer)
        for motor, dir in motors {
            addSubAction(mfc.motorAction(motor, enable: true))
            addSubAction(mfc.displacer)
            addSubAction(mfc.directionAction(motor, dir: dir))
        }

        for motor, _ in motors {
            let deadband = DeadbandStepAction(motor: motor, device: mfc.device, displacer: mfc.displacer)
            addSubAction(deadband)
        }
    }

    override func doExecution() {
        x = mfc.x
        y = mfc.y
        super.doExecution()
    }

    override func cleanup() {
        dX = mfc.x - x
        dY = mfc.y - y
        super.cleanup()
    }
}