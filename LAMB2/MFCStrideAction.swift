//
//  MFCStrideAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/3/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCStrideAction : SequenceAction {
    
    init(mfc: MFCSystem, motor: Int, dir: Bool, steps: Int, stride: UInt8 = 1) {
        
        super.init([mfc.motorAction(motor, enable: true),
            mfc.directionAction(motor, dir: dir)])
    }
}