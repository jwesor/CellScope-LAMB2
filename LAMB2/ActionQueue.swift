//
//  ActionQueue.swift
//  LAMB2
//  
//  Queue of actions. If the queue is exhausted and additional actions
//  are added, they will be run.
//
//  Created by Fletcher Lab Mac Mini on 2/13/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ActionQueue : ActionManager {
    
    let queue: NSOperationQueue

    init() {
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.suspended = true
    }
    
    func onActionCompleted(action: AbstractAction) {
    }
    
    func addAction(action: AbstractAction) {
        let operation = ActionOperation(action: action, manager: self)
        queue.addOperation(operation)
    }
    
    func beginActions() {
        queue.suspended = false
    }
}

class ActionOperation : NSOperation, ActionCompletionDelegate {
    
    let act: AbstractAction
    let man: ActionManager
    var exec: Bool
    var done: Bool
    
    init(action: AbstractAction, manager: ActionManager) {
        act = action
        man = manager
        exec = false
        done = false
        super.init()
    }
    
    override func start() {
        exec = true
        act.run(man, self)
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    override var executing: Bool {
        return exec
    }
    
    override var finished: Bool {
        return done
    }
    
    func onActionCompleted(action: AbstractAction) {
        self.willChangeValueForKey("isFinished")
        self.willChangeValueForKey("isExecuting")
        exec = false
        done = true
        self.didChangeValueForKey("isFinished")
        self.didChangeValueForKey("isExecuting")
    }
}