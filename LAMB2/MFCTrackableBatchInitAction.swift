//
//  MFCTrackableBatchInitAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableBatchInitAction : ImageProcessorAction {

    private let waypoint : MFCWaypoint
    private(set) let trackables : [MFCTrackable]
    private(set) let trackableParams:[(imX: Int, imY: Int, width: Int, height: Int)]

    init(waypoint: MFCWaypoint, trackables: [MFCTrackable], params: [(imX:Int, imY:Int, width: Int, height: Int)]) {
        self.waypoint = waypoint
        self.trackables = trackables
        self.trackableParams = params
        var imgprocessors: [ImageProcessor] = []
        let counts = min(trackables.count, params.count)
        for i in 0...counts-1 {
            imgprocessors += [trackables[i].displacement]
        }
        let mfc = waypoint.mfc
        super.init(imgprocessors, standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        let counts = min(trackables.count, trackableParams.count)
        for i in 0...counts-1 {
            let (imX, imY, width, height) = trackableParams[i]
            trackables[i].displacement.reset()
            trackables[i].displacement.centerTemplate = false
            trackables[i].displacement.templateX = Int32(imX)
            trackables[i].displacement.templateY = Int32(imY)
            trackables[i].displacement.templateWidth = Int32(width)
            trackables[i].displacement.templateHeight = Int32(height)
        }
        super.doExecution()
    }

    override func cleanup() {
        let counts = min(trackables.count, trackableParams.count)
        for i in 0...counts-1 {
            let (imX, imY, width, height) = trackableParams[i]
            trackables[i].initRelativeToWaypoint(self.waypoint, imX: imX, imY: imY, width: width, height: height)
        }
    }

}