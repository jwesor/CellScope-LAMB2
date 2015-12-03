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

    init(trackable: MFCTrackable, waypoint: MFCWaypoint, imX: Int, imY: Int, width: Int, height: Int) {
        self.imX = imX
        self.imY = imY
        self.width = width
        self.height = height
        self.trackable = trackable
        self.waypoint = waypoint
        let mfc = trackable.mfc
        super.init([trackable.displacement], standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        trackable.displacement.centerTemplate = false
        trackable.displacement.templateX = Int32(imX)
        trackable.displacement.templateY = Int32(imY)
        trackable.displacement.templateWidth = Int32(width)
        trackable.displacement.templateHeight = Int32(width)
        trackable.displacement.reset()
        super.doExecution()
    }

    override func cleanup() {
        trackable.initRelativeToWaypoint(waypoint, imX: imX, imY: imY, width: width, height: height)
    }

}