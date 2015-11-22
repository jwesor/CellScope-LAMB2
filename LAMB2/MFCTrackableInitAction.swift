//
//  MFCTrackableInitAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableInitAction : ImageProcessorAction {

    let trackable: MFCTrackable
    private let waypoint: MFCWaypoint
    private let imX: Int, imY: Int, width: Int, height: Int

    init(trackable: MFCTrackable, waypoint: waypoint, imX: Int, imY: Int, width: Int, height: Int) {
        self.imX = imX
        self.imY = imY
        self.width = width
        self.height = height
        self.trackable = trackable
        self.waypoint = waypoint
        super.init(trackable.getImageProcessors(), standby: 0, camera: trackable.waypoint.mfc)
        self.stage = waypoint.mfc.stage
    }

    override func doExecution() {
        trackable.initRelativeToWaypoint(waypoint, imX: imX, imY: imY, width: width, height: height)
        super.doExecution()
    }

}