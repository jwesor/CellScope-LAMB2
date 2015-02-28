//
//  ActionSequencer.swift
//  LAMB2
//
//  Sequence of actions to run. Once the sequence is executed,
//  no additonal actions may be added.
//
//  Created by Fletcher Lab Mac Mini on 2/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ActionSequencer: ActionManager {
    
    var actions:[AbstractAction]
    var running:Bool
    var completed:Bool
    var completionDelegates:[SequenceCompletionDelegate]
    
    init() {
        actions = []
        completionDelegates = []
        running = false
        completed = false
    }
    
    func addAction(action: AbstractAction) {
        if (!running) {
            actions.append(action)
        }
    }
    
    func beginActions() {
        if (!running) {
            running = true
            runNextAction()
        }
    }
    
    func runNextAction() {
        if (actions.count > 0) {
            let nextAction = actions.removeAtIndex(0)
            nextAction.run(self)
        } else {
            running = false
            for delegate in completionDelegates {
                delegate.onActionSequenceComplete()
            }
            completed = true
        }
    }
    
    func onActionCompleted(action: AbstractAction) {
        runNextAction()
    }
    
    func addCompletionDelegate(delegate: SequenceCompletionDelegate) {
        completionDelegates.append(delegate)
    }
    
}


protocol SequenceCompletionDelegate {
    
    func onActionSequenceComplete()
    
}