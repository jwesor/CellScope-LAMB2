//
//  MFCTrackableMapper.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackableMapper {
    
    unowned let mfc: MFCSystem
    private var trackables: [MFCTrackable] = []
    private var waypoints: [MFCWaypoint] = []
    private var trackablesByWaypoint: [MFCWaypoint : [MFCTrackable]] = [:]
    private var waypointsByTrackable: [MFCTrackable : MFCWaypoint] = [:]
    private var trackableHistories: [MFCTrackable : MFCTrackableMapHistory] = [:]
    var overlapThreshold = 0.8

    init(mfc: MFCSystem) {
        self.mfc = mfc
    }

    func registerTrackable(trackable: MFCTrackable, waypoint: MFCWaypoint, time: NSDate) {
        guard trackableHistories[trackable] == nil else {
            return
        }
        trackableHistories[trackable] = MFCTrackableMapHistory(trackable: trackable)
        trackableHistories[trackable]?.setStartTime(time)
        trackableHistories[trackable]?.update(time, waypoint: waypoint)
        waypointsByTrackable[trackable] = waypoint
        if trackablesByWaypoint[waypoint] == nil {
            trackablesByWaypoint[waypoint] = []
            waypoints.append(waypoint)
        }
        trackablesByWaypoint[waypoint]?.append(trackable)
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
            let tWidth = trackable.width
            let tHeight = trackable.height
            let minWidth = min(width, tWidth)
            let minHeight = min(height, tHeight)
            if abs(x - tX) <= minWidth || abs(y - tY) <= minHeight {
                let area = minWidth * minHeight
                let overlapWidth = min(max(x, tX) - min(x + width, tX + tWidth), 0)
                let overlapHeight = min(max(y, tY) - min(y + height, tY + tHeight), 0)
                let overlapArea = overlapWidth * overlapHeight
                if Double(overlapArea) > Double(area) * overlapThreshold {
                    return true
                }
            }
        }
        return false
    }

    func getExpectedTrackablesAtWaypoint(waypoint: MFCWaypoint) -> [MFCTrackable] {
        return trackablesByWaypoint[waypoint]!
    }
    
    func getClosestWaypoint(trackable: MFCTrackable) -> MFCWaypoint {
        var minD2 = Int.max
        var closest = waypointsByTrackable[trackable] != nil ? waypointsByTrackable[trackable]! : waypoints[0]
        for waypoint in waypoints {
            let dX = trackable.x - waypoint.x
            let dY = trackable.y - waypoint.y
            let d2 = dX * dX + dY * dY
            if d2 < minD2 {
                closest = waypoint
                minD2 = d2
            }
        }
        return closest
    }
}