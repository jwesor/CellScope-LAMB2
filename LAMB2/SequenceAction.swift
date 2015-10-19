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

class SequenceAction: AbstractAction, SequenceCompletionDelegate, ActionCompletionDelegate {
    
    let sequence: ActionSequencer = ActionSequencer()
    private var uniqueActions: [AbstractAction] = [] 
    private var repeating: [AbstractAction] = []
    
    override init() {
        super.init()
        sequence.addCompletionDelegate(self)
    }
    
    init(_ actions: [AbstractAction]) {
        super.init()
        addSubActions(actions)
        sequence.addCompletionDelegate(self)
    }
    
    func addSubAction(action: AbstractAction) {
        repeating.append(action)
        sequence.addAction(action)
        if !uniqueActions.contains(action) {
            uniqueActions.append(action)
        }
    }
    
    func addSubActions(actions: [AbstractAction]) {
        for action in actions {
            repeating.append(action)
            sequence.addAction(action)
            if !uniqueActions.contains(action) {
                uniqueActions.append(action)
            }
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
        for action in uniqueActions {
            action.addCompletionDelegate(self)
        }
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
        for action in uniqueActions {
            action.removeCompletionDelegate(self)
        }
    }
    
    func clearActions() {
        repeating = []
        uniqueActions = []
        sequence.clearSequence()
    }

    func onActionSequenceComplete(action: AbstractAction) {}
    
}