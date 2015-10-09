//
//  MFCIntraMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCIntraMoveAction : SequenceAction {

    let mfc: MFCSystem

    init(mfc: MFCSystem, motorSteps:[Int:Float] stride: UInt8 = 1) {
        self.mfc = mfc
        super.init()
    }

}