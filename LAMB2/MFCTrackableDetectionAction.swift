//
//  MFCTrackableDetectionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDetectionAction : SequenceAction {
   
    let waypoint: MFCWaypoint
    let positionAction: MFCWaypointDisplacementAction
    let detectAction: ImageProcessorAction
    let detector: IPDetectContourTrackables = IPDetectContourTrackables()
    var detectedTrackables: [MFCTrackable] = []
   
    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        positionAction = MFCWaypointDisplacementAction(waypoint: waypoint, updateMfc: true)
        let mfc = waypoint.mfc
        detectAction = ([detector], standby: 0, camera: mfc.camera, stage: mfc.stage)
        super.init([positionAction, detectAction])
    }

    override func onActionCompleted(action: AbstractAction) {
        if action === detectAction {
            detectedTrackables = []
            let counts = processor.detectedCount
            for i in 0...counts-1 {
                let trackable = MFCTrackable()
                detectedTrackables.append(trackable)

                let result = detector.getDetectedTrackable(i)
                let x = Int(result.x), y = Int(result.y), width = Int(result.width), height = Int(result.height)

                let initAction = MFCTrackableInitAction(trackable: trackable, waypoint: waypoint, imX: x, imY: y, width: width, height: height)
                addOneTimeAction(initAction)
            }
        }
    }

}