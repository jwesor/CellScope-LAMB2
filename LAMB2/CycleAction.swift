//
//  CycleAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/18/16.
//  Copyright © 2016 Fletchlab. All rights reserved.
//

import Foundation

class CycleAction : AbstractAction, ActionCompletionDelegate {
    
    private let singleCycleAction: SequenceAction = SequenceAction()
    private let cyclesAction: SequenceAction = SequenceAction()
    private let initialDelayAction: MinDurationAction
    var cycles: Int
    
    init(cycles: Int) {
        self.cycles = cycles
        initialDelayAction = MinDurationAction(action: AbstractAction(), seconds: 0)
        super.init()
    }
    
    func clearActions() {
        singleCycleAction.clearActions()
    }
    
    func setNumberOfCycles(cycles: Int) {
        self.cycles = cycles
    }
    
    func addAction(action: AbstractAction) {
        singleCycleAction.addSubAction(action)
    }
    
    func addActionWithMinDuration(action: AbstractAction, seconds: Double) {
        if seconds > 0 {
            let actionWithDuration = MinDurationAction(action: action, seconds: seconds)
            singleCycleAction.addSubAction(actionWithDuration)
        } else {
            singleCycleAction.addSubAction(action)
        }
    }
    
    func setInitialDelay(seconds: Double) {
        initialDelayAction.duration = seconds
    }
    
    override func doExecution() {
        cyclesAction.addOneTimeAction(initialDelayAction)
        for _ in 1...cycles {
            cyclesAction.addOneTimeAction(singleCycleAction)
        }
        cyclesAction.run(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (action == cyclesAction) {
            finish()
        }
    }
}