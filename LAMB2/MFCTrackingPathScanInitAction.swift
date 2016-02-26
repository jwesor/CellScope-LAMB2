//
//  MFCTrackingPathScanInitAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackingPathScanInitAction: SequenceAction {

	let mfc: MFCSystem
	let mapper: MFCTrackableMapper

	init(mapper: MFCTrackableMapper, path: [(angle: Double, steps: Int)]) {
		self.mapper = mapper
		self.mfc = mapper.mfc

		let startingWaypoint = MFCWaypoint(mfc: mfc)
		let startingWaypointInitAction = MFCWaypointInitAction(waypoint: startingWaypoint)
		let startingMapperAction = MFCTrackableMapperDetectInitRegisterAction(mapper: mapper, waypoint: startingWaypoint)

		var actions = [startingWaypointInitAction, startingMapperAction]

		for angle, steps in path {
			let dX = Int(round(cos(angle) * steps))
			let dY = Int(round(sin(angle) * steps))
			let moveAction = MFCMoveAction(mfc: mfc, dX: dX, dY: dY)
			let waypoint = MFCWaypoint(mfc: mfc)
			let waypointInitAction = MFCWaypoingInitAction(waypoint: waypoint)
			let mapperAction = MFCTrackableMapperDetectInitRegisterAction(mapper: mapper, waypoint: waypoint)
			actions += [moveAction, waypointInitAction, mapperAction]
		}

		super.init(actions)
	}

	convenience init(mapper: MFCTrackableMapper, pathInFovs: [(angle: Double, fovs: Double)]) {
		var pathInSteps: [(angle: Double, steps: Int)] = [:]
		let stage = mapper.mfc.stage
		let fovWidth, fovHeight = stage.getFovDimens()
		let fovSize = min(fovWidth, fovHeight)
		for angle, fovs in pathInFovs {
			pathInSteps.append((angle: angle, steps: Int(fovSize * fovs)))
		}
		self.init(mapper: mapper, path: pathInSteps)
	}

	convenience init(mapper: MFCTrackableMapper, pathAngles: [Double], intervalInFovs: Double = 0.5) {
		let pathInFovs: [(angle: Double, fovs: Double)] = [:]
		for angle in pathAngles {
			pathInFovs.append((angle: angle, fovs: 0.intervalInFovs))
		}
		self.init(mapper: mapper, pathInFovs: pathInFovs)
	}
}