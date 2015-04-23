//
//  ActionCycler.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/22/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ActionCycler {
    
    let queue: ActionManager
    var running: Bool
    var times: [Double]
    var actions: [Double: [AbstractAction]]
    var cycleDuration: Double
    var remainingIterations: Int
    var currentTimeIndex: Int
    
    init(queue: ActionManager) {
        self.queue = queue
        times = [Double]()
        actions = [Double: [AbstractAction]]()
        cycleDuration = 0
        running = false
        remainingIterations = 0
        currentTimeIndex = 0
    }
    
    func addAction(action: AbstractAction, delay: Double) {
        if running {
            return
        }
        cycleDuration += max(0, delay)
        if actions[cycleDuration] != nil {
            actions[cycleDuration]!.append(action)
        } else {
            times.append(delay)
            actions[cycleDuration] = [action]
        }
    }
    
    func addActionSequence(sequence: [AbstractAction], delay: Double) {
        addAction(SequenceAction(sequence), delay: delay)
    }
    
    func startCycle(duration: Double) {
        startCycle(ceil(duration / cycleDuration))
    }
    
    func startCycle(iterations: Int) {
        if (running || times.count == 0 || iterations <= 0) {
            return
        }
        running = true
        remainingIterations = iterations
        currentTimeIndex = -1
        nextAction()
    }
    
    func nextAction() {
        println("remaining iterations: \(remainingIterations)")
        currentTimeIndex += 1
        if currentTimeIndex >= times.count {
            currentTimeIndex = 0
            remainingIterations -= 1
        }
        if remainingIterations > 0 {
            let currentTime = times[currentTimeIndex]
            if (currentTime == 0) {
                println("actions queued")
                for action in actions[currentTime]! {
                    queue.addAction(action)
                }
                nextAction()
            } else {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(currentTime * Double(NSEC_PER_SEC)))
                println("delaying for \(currentTime)")
                dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                    for action in self.actions[currentTime]! {
                        println("actions queued")
                        self.queue.addAction(action)
                    }
                    self.nextAction()
                })
            }
        } else {
            println("completed cycles")
            cyclesComplete()
        }
    }
    
    func cyclesComplete() {
        running = false
    }
    
}