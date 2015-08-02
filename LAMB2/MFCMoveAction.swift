//
//  MFCMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCMoveAction : SequenceAction {
    
    
    init(_ mfc: MFCSystem, x: Int, y: Int) {
        super.init()
        let stage = mfc.stage
    }
    
}