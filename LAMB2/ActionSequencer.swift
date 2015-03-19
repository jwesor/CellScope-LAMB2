//
//  ActionSequencer.swift
//  LAMB2
//
//  Sequence of actions to run. Once the sequence is completed,
//  no additonal actions may be added.
//
//  It's generally preferable to use an ActionQueue. This class
//  mainly exists as a part of SequenceAction's implentation.
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
        actions.append(action)
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