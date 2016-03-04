//
//  MFCTrackingPathScanNextWaypointAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/23/16.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackingPathScanNextWaypointAction: SequenceAction {

	unowned let mfc: MFCSystem
	unowned let mapper: MFCTrackableMapper
    let waypoint: MFCWaypoint
    let moveAction: MFCWaypointMoveToAction
    
    init(mapper: MFCTrackableMapper, waypoint: MFCWaypoint) {
		self.mapper = mapper
		self.mfc = mapper.mfc
        self.waypoint = waypoint
        moveAction = MFCWaypointMoveToAction(waypoint: waypoint)
        super.init([moveAction])
	}
    
    override func doExecution() {
        let trackables = mapper.getExpectedTrackablesAtWaypoint(waypoint)
        for trackable in trackables {
            // TODO: make this a batch update action
            let updateAction = MFCTrackableUpdateAction(trackable: trackable)
            addOneTimeAction(updateAction)
        }
        super.doExecution()
    }

}