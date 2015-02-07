//
//  AbstractAction.swift
//  LAMB2
//
//  Template class for actions to be used with ActionSequencer.
//  Subclasses shoudl override doExecution(), and call finish()
//  when complete.
//
//  Created by Fletcher Lab Mac Mini on 2/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class AbstractAction {
    
    var seq:ActionSequencer?
    var running:Bool
    
    init() {
        running = false
    }
    
    final func run(sequencer: ActionSequencer? = nil) {
        seq = sequencer
        doExecution()
        running = true
    }
    
    final func finish() {
        if running {
            seq?.runNextAction()
            running = false
            seq = nil
        }
    }
    
    func doExecution() {
        finish()
    }
    
}