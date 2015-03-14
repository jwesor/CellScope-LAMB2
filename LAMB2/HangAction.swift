//
//  HangAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/13/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class HangAction : AbstractAction {
    
    override init() {
        super.init()
        self.timeout = 3
    }
    
    override func doExecution() {
        // Do nothing. Things get stuck!
    }
}