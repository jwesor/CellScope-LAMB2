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
    let trackables : [MFCTrackable]
    private var trackableParams:[(imX: Int, imY: Int, width: Int, height: Int)]

    init(mapper: MFCTrackableMapper, waypoint: MFCWaypoint, params: [(imX:Int, imY:Int, width: Int, height: Int)]) {
        self.waypoint = waypoint
        self.trackableParams = params
        var imgprocessors: [ImageProcessor] = []
        var tmpTrackables: [MFCTrackable] = []
        for _ in params {
            let trackable = MFCTrackable(mapper: mapper)
            tmpTrackables.append(trackable)
            imgprocessors += [trackable.displacement]
        }
        trackables = tmpTrackables
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