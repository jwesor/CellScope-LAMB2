//
//  MFCTrackableDetectInitAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDetectInitAction : SequenceAction {

    unowned let mfc: MFCSystem
    unowned let mapper: MFCTrackableMapper
    unowned let waypoint: MFCWaypoint
    private let detectAction: MFCTrackableDetectAction

    init(mapper: MFCTrackableMapper, waypoint: MFCWaypoint) {
        self.mapper = mapper
        self.waypoint = waypoint
        self.mfc = mapper.mfc
        let wpInitAction = MFCWaypointInitAction(waypoint: waypoint)
        detectAction = MFCTrackableDetectAction(mfc: mfc)
        super.init([wpInitAction, detectAction])
    }

    override func onActionCompleted(action: AbstractAction) {
        if action === detectAction {
            let initAction = MFCTrackableBatchInitAction(mapper: mapper, waypoint: waypoint, params: detectAction.trackableParams)
            addOneTimeAction(initAction)
        }
    }

}