//
//  SequenceAction.swift
//  LAMB2
//
//  Action that bundles a sequence of other sub-actions
//  into one.
//
//  Created by Fletcher Lab Mac Mini on 2/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class SequenceAction: AbstractAction, SequenceCompletionDelegate {
    
    let sequence:ActionSequencer
    
    override init() {
        sequence = ActionSequencer()
        super.init()
    }
    
    func addSubAction(action: AbstractAction) {
        sequence.addAction(action)
    }
    
    override func doExecution() {
        sequence.addCompletionDelegate(self)
        sequence.beginActions()
    }
    
    func onActionSequenceComplete() {
        finish()
    }
    
}