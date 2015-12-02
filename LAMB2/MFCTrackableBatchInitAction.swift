//
//  MFCTrackableBatchInitAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableBatchInitAction : ImageProcessorAction {

    private let waypoint : MFCWaypoint
    private let trackables : [MFCTrackable:(imX: Int, imY: Int, width: Int, height: Int)]

    init(waypoint: MFCWaypoint, trackables: [MFCTrackable : (imX:Int, imY:Int, width:Int, height:Int)]) {
        self.waypoint = waypoint
        self.trackables = trackables
        var imgprocessors = []
        for trackable, param in trackables {
            imgprocessors += trackable.getImageProcessors()
        }
        let mfc = waypoint.mfc
        super.init(imgprocessors, standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        for trackable, params in trackables {
            let (imX, imY, width, height) = params
            trackable.displacement.centerTemplate = false
            trackable.displacement.templateX = Int32(imX)
            trackable.displacement.templateY = Int32(imY)
            trackable.displacement.templateWidth = Int32(width)
            trackable.displacement.templateHeight = Int32(width)
        }
        super.doExecution()
    }

    override func cleanup() {
        for trackable, params in trackables {
            let (imX, imY, width, height) = params
            trackable.initRelativeToWaypoint(waypoint, imX: imX, imY: imY, width: width, height: height)
        }
    }

}