//
//  MFCMoveToAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/12/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCMoveToAction : SequenceAction {
    
    let mfc: MFCSystem
    let x: Int, y: Int
    let stride: UInt8
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 0) {
        self.mfc = mfc
        self.x = x
        self.y = y
        self.stride = stride
        super.init()
    }
    
    override func doExecution() {
        let moveAction = MFCMoveAction(mfc: mfc, dX: x - mfc.x, dY: y - mfc.y, stride: stride)
        addOneTimeAction(moveAction)
        super.doExecution()
    }
    
}