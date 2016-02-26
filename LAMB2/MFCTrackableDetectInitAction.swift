//
//  MFCTrackableDetectInitAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDetectInitAction : SequenceAction {

    let waypoint: MFCWaypoint
    let detectAction: MFCTrackableDetectAction

    init(mfc: MFCSystem) {
        waypoint = MFCWaypoint(mfc: mfc)
        let wpInitAction = MFCWaypointInitAction(waypoint: waypoint)
        detectAction = MFCTrackableDetectAction(mfc: mfc)
        super.init([wpInitAction, detectAction])
    }

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        detectAction = MFCTrackableDetectAction(mfc: waypoint.mfc)
        super.init([detectAction])
    }

    override func onActionCompleted(action: AbstractAction) {
        if action === detectAction {
            let initAction = MFCTrackableBatchInitAction(waypoint: waypoint, trackables: detectAction.detectedTrackables, params: detectAction.trackableParams)
            addOneTimeAction(initAction)
        }
    }

}