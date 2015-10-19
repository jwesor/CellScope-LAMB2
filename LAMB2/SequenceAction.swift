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
    private var uniqueRuntimeActions: [AbstractAction] = []
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
        if !uniqueRuntimeActions.contains(action) {
            uniqueActions.append(action)
            uniqueRuntimeActions.append(action)
        }
    }
    
    func addSubActions(actions: [AbstractAction]) {
        for action in actions {
            addSubAction(action)
        }
    }
    
    func addOneTimeAction(action: AbstractAction) {
        sequence.addAction(action)
        if !uniqueRuntimeActions.contains(action) {
            uniqueRuntimeActions.append(action)
            if state == ActionState.RUNNING {
                action.addCompletionDelegate(self)
            }
        }
    }
    
    func addOneTimeActions(actions: [AbstractAction]) {
        for action in actions {
            addOneTimeAction(action)
        }
    }
    
    override func doExecution() {
        for action in uniqueRuntimeActions {
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
        for action in uniqueRuntimeActions {
            action.removeCompletionDelegate(self)
        }
        uniqueRuntimeActions = uniqueActions
    }
    
    func clearActions() {
        repeating = []
        uniqueActions = []
        sequence.clearSequence()
    }

    func onActionCompleted(action: AbstractAction) {}
    
}