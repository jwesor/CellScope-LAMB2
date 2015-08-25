//
//  MFCDirectionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/25/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCDirectionAction : SequenceAction, ActionCompletionDelegate {
    
    private let mfc : MFCSystem
    private let direction : StageDirectionAction
    private let backlash : StageMoveAction
    private let stage: StageState
    
    init(_ mfc : MFCSystem, motor: Int, dir: Bool) {
        self.mfc = mfc
        stage = mfc.stage
        direction = StageDirectionAction(mfc.device, motor: motor, dir: dir, stage: stage)
        let backlashSteps = stage.getBacklash(motor, dir: dir)
        backlash = StageMoveAction(mfc.device, motor: motor, steps: backlashSteps, stage: stage)
        super.init([direction])
        direction.addCompletionDelegate(self)
    }
    
    func onActionCompleted(action: AbstractAction) {
        if direction.changed {
            addOneTimeActions([backlash, mfc.displacer])
        }
    }
}