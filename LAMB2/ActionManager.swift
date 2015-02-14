//
//  ActionManager.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/13/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

protocol ActionManager : ActionCompletionDelegate {
    func addAction(action: AbstractAction)
    func beginActions()
}