//
//  ActionSequencer.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ActionSequencer {
    
    var actions:[AbstractAction]
    var running:Bool
    var completionDelegates:[SequenceCompletionDelegate]
    
    init() {
        actions = []
        completionDelegates = []
        running = false
    }
    
    func addAction(action: AbstractAction) {
        actions.append(action)
    }
    
    func executeSequence() {
        if (!running) {
            running = true
            runNextAction()
        }
    }
    
    func runNextAction() {
        if (actions.count > 0) {
            let action = actions.removeAtIndex(0)
            action.run(sequencer: self)
        } else {
            running = false
            for delegate in completionDelegates {
                delegate.onActionSequenceComplete()
            }
        }
    }
    
    func addCompletionDelegate(delegate: SequenceCompletionDelegate) {
        completionDelegates.append(delegate)
    }
    
}


protocol SequenceCompletionDelegate {
    
    func onActionSequenceComplete()
    
}