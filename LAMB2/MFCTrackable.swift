//
//  MFCTrackable.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackable {
    
    private(set) var waypoint: MFCWaypoint?
    let displacement: IPDisplacement()
    private(set) var x: Int, y: Int
    private(set) var timeZero: NSDate?
    private var timestamps: [NSTimeInterval] = []
    private var positions: [(x: Int, y: Int)] = []
    private var waypoints: [MFCWaypoint]
    var recordHistory: Bool = true
    
    init(x: Int = 0, y: Int = 0) {
        diplacement = IPDisplacement()
        displacement.updateTemplate = true
        displacement.centerTemplate = false
        displacement.trackTemplate = true
        self.x = x
        self.y = y
    }

    func updateLocation(time: NSDate, x: Int, y: Int) {
        self.x = x
        self.y = y
        if self.recordHistory {
            positions.append((x: x, y: y))
            timestamps.append(time.timeIntervalSinceDate(timeZero))
        }
    }

    func updateWaypointAndLocation(time: NSDate, waypoint: MFCWaypoint, x: Int, y: Int) {
        updateLocation(time, x: x, y: y)
        if self.recordHistory {
            waypoints.append(waypoint)
        }
    }

    func initRelativeToWaypoint(waypoint: MFCWaypoint, time: NSDate, imX: Int, imY: Int, width: Int, height: Int) {
        self.waypoint = waypoint
        (x, y) = waypoint.mfc = mfc.imgPointToMfcLocation(imX: imX, imY: imY)
        displacement.templateX = Int32(x)
        displacement.templateY = Int32(y)
        displacement.templateWidth = Int32(width)
        displacement.templateHeight = Int32(height)
        timeZero = time
        self.updateWaypointAndLocation(time, waypoint: waypoint, x: x, y: y)
    }

    func getImageProcessors() -> [getImageProcessorseProcessor] {
        return [displacement]
    }

}