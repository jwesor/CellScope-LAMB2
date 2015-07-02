//
//  SequenceAction.swift
//  LAMB2
//
//  Action that bundles a sequence of other sub-actions
//  into one single action.
//
//  Created by Fletcher Lab Mac Mini on 2/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class SequenceAction: AbstractAction, SequenceCompletionDelegate {
    
    let sequence: ActionSequencer = ActionSequencer()
    var repeating: [AbstractAction] = []
    
    override init() {
        super.init()
    }
    
    init(_ actions: [AbstractAction]) {
        super.init()
        for action in actions {
            repeating.append(action)
            sequence.addAction(action)
            
        }
    }
    
    func addSubAction(action: AbstractAction) {
        repeating.append(action)
        sequence.addAction(action)
    }
    
    func addSubActions(actions: [AbstractAction]) {
        for action in actions {
            repeating.append(action)
            sequence.addAction(action)
        }
    }
    
    func addOneTimeAction(action: AbstractAction) {
        sequence.addAction(action)
    }
    
    func addOneTimeActions(actions: [AbstractAction]) {
        for action in actions {
            sequence.addAction(action)
        }
    }
    
    override func doExecution() {
        sequence.addCompletionDelegate(self)
        sequence.beginActions()
    }
    
    func onActionSequenceComplete() {
        finish()
    }
    
    override func cleanup() {
        sequence.clearSequence()
        for action in repeating {
            sequence.addAction(action)
        }
    }
    
    func clearActions() {
        repeating = []
        sequence.clearSequence()
    }
    
}