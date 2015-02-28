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

class AbstractAction: NSObject {
    
    var running:Bool
    var completionDelegates:[ActionCompletionDelegate]
    var runtimeCompletionDelegates:[ActionCompletionDelegate]
    
    override init() {
        running = false
        completionDelegates = []
        runtimeCompletionDelegates = []
    }
    
    final func run(delegates: ActionCompletionDelegate...) {
        runtimeCompletionDelegates += delegates
        doExecution()
        running = true
    }
    
    final func finish() {
        if running {
            running = false
            for delegate in completionDelegates {
                delegate.onActionCompleted(self)
            }
            for delegate in runtimeCompletionDelegates {
                delegate.onActionCompleted(self)
            }
            runtimeCompletionDelegates = []
        }
    }
    
    func doExecution() {
        finish()
    }
    
    func addCompletionDelegate(delegate: ActionCompletionDelegate) {
        completionDelegates.append(delegate)
    }
}

protocol ActionCompletionDelegate {
    func onActionCompleted(action: AbstractAction)
}