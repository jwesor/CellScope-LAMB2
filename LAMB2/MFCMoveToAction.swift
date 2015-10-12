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
    
    init(mfc: MFCSystem, x: Int, y: Int, stride: UInt8 = 1) {
        self.mfc = mfc
        self.x = x
        self.y = y
        self.stride = stride
        super.init()
    }
    
    override func doExecution() {
        print("TARGET MOTION \(x - mfc.x) \(y - mfc.y)")
        let moveAction = MFCMoveAction(mfc: mfc, dX: x - mfc.x, dY: y - mfc.y)
        addOneTimeAction(moveAction)
        super.doExecution()
    }
    
}