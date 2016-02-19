//
//  ActionCycler.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/22/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ActionCycler {
    
    let queue: ActionQueue
    var running: Bool = false
    var delays: [Double] = []
    var actions: [Double: [AbstractAction]] = [:]
    var cycleDuration: Double = 0
    var postCycleDelay: Double = 0
    var remainingIterations: Int = 0
    var currentTimeIndex: Int = 0
    var currentTime: Double = 0
    
    init(actionQueue: ActionQueue) {
        queue = actionQueue
    }
    
    func setPostCycleDelayDuration(delay: Double) {
        postCycleDelay = delay
    }
    
    func addAction(action: AbstractAction, delay: Double) {
        if running {
            return
        }
        cycleDuration += max(0, delay)
        if actions[cycleDuration] != nil {
            actions[cycleDuration]!.append(action)
        } else {
            delays.append(delay)
            actions[cycleDuration] = [action]
        }
    }
    
    func addActionSequence(sequence: [AbstractAction], delay: Double) {
        addAction(SequenceAction(sequence), delay: delay)
    }
    
    func runForDuration(duration: Double) {
        runCycles(Int(ceil(duration / (cycleDuration + postCycleDelay))))
    }
    
    func runCycles(iterations: Int) {
        if (running || delays.count == 0 || iterations <= 0) {
            return
        }
        print("starting cycles!")
        print("\(actions)")
        print("\(delays)")
        DebugUtil.setLogEnabled("action", enabled: true)
        DebugUtil.setLogEnabled("cycle", enabled: true)
        DebugUtil.setLogEnabled("drive", enabled: true)
        DebugUtil.log("cycle", "initiated cycle for \(iterations) iterations")
        running = true
        remainingIterations = iterations - 1
        currentTimeIndex = -1
        currentTime = 0
        nextAction()
    }
    
    private func nextAction() {
        currentTimeIndex += 1
        var currentDelay = 0.0
        if currentTimeIndex >= delays.count {
            currentDelay += postCycleDelay
            currentTimeIndex = 0
            currentTime = 0
            remainingIterations -= 1
            DebugUtil.log("cycle", "cycle iterations remaining: \(remainingIterations)")
        }
        if remainingIterations >= 0 {
            currentDelay += delays[currentTimeIndex]
            currentTime += delays[currentTimeIndex]
            print("next action is in \(currentDelay)")
            if (currentDelay == 0) {
                // No delay, add next set of actions immediately
                for action in actions[currentDelay]! {
                    queue.addAction(action)
                    DebugUtil.log("cycle", "adding \(action)\(action.logName)")
                }
                nextAction()
            } else {
                // Add actions after currentDelay sections
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64((currentDelay) * Double(NSEC_PER_SEC)))
                DebugUtil.log("cycle", "waiting to execute \(self.actions[currentTime]) after \(currentDelay) seconds")
                dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                    for action in self.actions[self.currentTime]! {
                        self.queue.addAction(action)
                        DebugUtil.log("cycle", "adding \(action)\(action.logName)")
                    }
                    self.nextAction()
                })
            }
        } else {
            cyclesComplete()
        }
    }
    
    private func cyclesComplete() {
        DebugUtil.log("cycle", "cycles completed")
        DebugUtil.setLogEnabled("action", enabled: false)
        DebugUtil.setLogEnabled("cycle", enabled: false)
        DebugUtil.setLogEnabled("drive", enabled: false)
        running = false
    }
    
}