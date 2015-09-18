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
    
    var state:ActionState
    var completionDelegates:[ActionCompletionDelegate] = []
    var temporaryCompletionDelegates:[ActionCompletionDelegate] = []
    var runtimeCompletionDelegates:[ActionCompletionDelegate] = []
    var timeout: Double
    var logName: String = ""
    
    override init() {
        state = ActionState.READY
        timeout = 0
    }
    
    final func run(delegates: ActionCompletionDelegate...) {
        DebugUtil.log("\(self)\n")
        DebugUtil.log("action", "\(self)\(logName) started")
        runtimeCompletionDelegates += delegates
        state = ActionState.RUNNING
        if timeout > 0 {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                self.finish(completed: false)
            })
        }
        
        doExecution()
    }
    
    final func finish(completed:Bool = true) {
        if state != ActionState.RUNNING {
            return
        }
        DebugUtil.log("action", "\(self) finished. completed: \(completed)")
        let lockQueue = dispatch_queue_create("action completion queue", nil)
        dispatch_sync(lockQueue) {
            if self.state == ActionState.RUNNING {
                self.state = (completed ? ActionState.COMPLETED : ActionState.TIMED_OUT)
                self.cleanup()
                let tmpDelegates = self.runtimeCompletionDelegates
                self.runtimeCompletionDelegates = []
                for delegate in self.completionDelegates {
                    delegate.onActionCompleted(self)
                }
                for delegate in tmpDelegates {
                    delegate.onActionCompleted(self)
                }
            }
        }
    }
    
    // Override to dictate action behavior
    func doExecution() {
        finish()
    }
    
    // Override to implement any on-finish behavior.
    // Particularly useful if the action added a delegate/listener
    // to something during execution and needs to be removed.
    func cleanup() {
    }
    
    func addCompletionDelegate(delegate: ActionCompletionDelegate) {
        completionDelegates.append(delegate)
    }
    
    func addOneTimeCompletionDelegate(delegate: ActionCompletionDelegate) {
        runtimeCompletionDelegates.append(delegate)
    }
}

enum ActionState {
    case READY
    case RUNNING
    case COMPLETED
    case TIMED_OUT
}

protocol ActionCompletionDelegate {
    func onActionCompleted(action: AbstractAction)
}