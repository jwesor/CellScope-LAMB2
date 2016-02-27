//
//  MFCTrackablePositionUpdateAction.swift
//  LAMB2
//
//  Find how much the trackable has moved by and update the location
//
//  Created by Fletcher Lab Mac Mini on 2/26/16.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableUpdateAction : MFCTrackableDisplacementAction {

    override init(trackable: MFCTrackable, searchWidth: Int, searchHeight: Int) {
        super.init(trackable: trackable, searchWidth: searchWidth, searchHeight: searchHeight)
        self.updateFrame = true
    }
    
    convenience init(trackable: MFCTrackable, searchSize: Int) {
        self.init(trackable: trackable, searchWidth: searchSize, searchHeight: searchSize)
    }
    
    override func cleanup() {
        // TODO: make this update trackable location
    }
}