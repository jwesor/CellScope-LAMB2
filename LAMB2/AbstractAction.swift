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
    
    var running:Bool
    var completionDelegates:[ActionCompletionDelegate]
    
    init() {
        running = false
        completionDelegates = []
    }
    
    final func run(delegates: ActionCompletionDelegate...) {
        completionDelegates += delegates
        doExecution()
        running = true
    }
    
    final func finish() {
        if running {
            for delegate in completionDelegates {
                delegate.onActionCompleted()
            }
            completionDelegates = []
            running = false
        }
    }
    
    func doExecution() {
        finish()
    }
    
}

protocol ActionCompletionDelegate {
    func onActionCompleted()
}