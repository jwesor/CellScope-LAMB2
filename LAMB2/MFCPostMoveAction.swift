//
//  Cleans up the MFC after moving.
//  Disables the motors and checks for displacement.  
//
//  MFCPostMoveAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/8/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCPostMoveAction : SequenceAction {

    let mfc: MFCSystem

    init(mfc: MFCSystem, motors: [Int]) {
        self.mfc = mfc
        super.init()
        for motor in motors {
            addSubAction(mfc.motorAction(motor, enable: false))
        }
        addSubAction(mfc.displacer)
    }
}