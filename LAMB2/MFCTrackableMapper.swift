//
//  MFCTrackableMapper.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackableMapper {
    
    let mfc: MFCSystem
    private(set) var trackables: [MFCTrackable] = []
    private(set) var waypoints: [MFCWaypoint] = []
    private(set) var waypointIndex: Int = 0
    var overlapThreshold = 0.8

    init(mfc: MFCSystem) {
        self.mfc = mfc
    }

    func registerTrackable(trackable: MFCTrackable, waypoint: MFCWaypoint) {
        if !trackables.contains(trackable) {
            trackables.append(trackable)
        }
        if !waypoints.contains(waypoint) {
            waypoints.append(waypoint)
        }
    }

    func nextWaypoint() -> MFCWaypoint {
        let currentWaypoint = waypoints[waypointIndex]
        waypointIndex = (waypointIndex + 1) % waypoints.count
        return currentWaypoint
    }

    func isRedundantTrackable(bounds: (imX: Int, imY: Int, width: Int, height: Int)) -> Bool {
    	return self.isRedundantTrackable(x: bounds.imX, y: bounds.imY, width: bounds.width, height: bounds.height)
    }

    func isRedundantTrackable(x x: Int, y: Int, width: Int, height: Int) -> Bool {
        for trackable in trackables {
            // Calculate the overlapping area between the two rectangles.
            // If overlap is greater than OVERLAPTHRESHOLD of the min width * min height,
            // a new trackable would be redundant.
            let tX = trackable.x
            let tY = trackable.y
            let tWidth = trackable.w
            let tHeight = trackable.h
            let minWidth = min(width, tWidth)
            let minHeight = min(height, tHeight)
            if abs(x - tX) <= minWidth || abs(y - tY) <= minHeight {
                let area = minWidth * minHeight
                let overlapWidth = min(max(x, tX) - min(x + width, tX + tWidth), 0)
                let overlapHeight = min(max(y, tY) - min(y + height, tY + tHeight), 0)
                let overlapArea = overlapWidth * overlapHeight
                if overlapArea > area * overlapThreshold {
                    return true
                }
            }
        }
        return false
    }

    func getExpectedTrackablesAtWaypoint(waypoint: MFCWaypoint) -> [MFCTrackable] {
        var found = []
        for t in trackables {
            if t.waypoint == waypiont {
                found.append(t)
            }
        }
        return t
    }
}