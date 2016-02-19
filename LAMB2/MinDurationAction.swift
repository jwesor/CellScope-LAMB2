//
//  MinDurationAction.swift
//  LAMB2
//
//  Wrapping an action in a MinDurationAction will execute
//  the same action, but will ensure that the action does not
//  complete for at least the number of seconds given.
//
//  Created by Fletcher Lab Mac Mini on 2/18/16.
//  Copyright © 2016 Fletchlab. All rights reserved.
//

import Foundation

class MinDurationAction : AbstractAction, ActionCompletionDelegate {
    
    let action: AbstractAction
    var duration: Double
    private var actionComplete: Bool = false
    private var timerComplete: Bool = false
    
    init(action: AbstractAction, seconds: Double) {
        self.action = action
        self.duration = seconds
        super.init()
    }
    
    override func doExecution() {
        actionComplete = false
        if duration > 0 {
            timerComplete = false
            let dispatchTimeDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTimeDelay, dispatch_get_main_queue(), { () -> Void in
                self.timerComplete = true
                self.checkForCompletion()
            })
        } else {
            timerComplete = true
        }
        action.run(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (action == self.action) {
            actionComplete = true
            checkForCompletion()
        }
    }
    
    private func checkForCompletion() {
        let lockQueue = dispatch_queue_create("edu.berkeley.fletchlab.LAMB2.MinDurationAction", nil)
        dispatch_sync(lockQueue) {
            if self.timerComplete && self.actionComplete {
                self.finish()
            }
        }
    }
    
    override func cleanup() {
    
    }
}