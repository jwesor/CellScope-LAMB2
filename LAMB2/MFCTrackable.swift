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
    let mfc: MFCSystem
    let displacement: IPDisplacement = IPPyramidDisplacement()
    private(set) var width: Int, height: Int
    private(set) var x: Int, y: Int
    private(set) var timeZero: NSDate?
    private var timestamps: [NSTimeInterval] = []
    private var positions: [(x: Int, y: Int)] = []
    private var waypoints: [MFCWaypoint] = []
    var recordHistory: Bool = true
    
    init(mfc: MFCSystem, x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0) {
        self.mfc = mfc
        displacement.updateTemplate = true
        displacement.centerTemplate = false
        displacement.trackTemplate = true
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    func updateLocation(time: NSDate, x: Int, y: Int) {
        self.x = x
        self.y = y
        if self.recordHistory {
            positions.append((x: x, y: y))
            if timeZero != nil {
                timestamps.append(time.timeIntervalSinceDate(timeZero!))
            } else {
                timestamps.append(time.timeIntervalSince1970)
            }
        }
    }

    func updateWaypointAndLocation(time: NSDate, waypoint: MFCWaypoint, x: Int, y: Int) {
        updateLocation(time, x: x, y: y)
        if self.recordHistory {
            waypoints.append(waypoint)
        }
    }
    
    func initRelativeToWaypoint(waypoint: MFCWaypoint, imX: Int, imY: Int, width: Int, height: Int) {
        let time = displacement.currentFrameTime
        self.initRelativeToWaypoint(waypoint, time: time, imX: imX, imY: imY, width: width, height: height)
    }

    func initRelativeToWaypoint(waypoint: MFCWaypoint, time: NSDate, imX: Int, imY: Int, width: Int, height: Int) {
        let mfc = waypoint.mfc
        self.waypoint = waypoint
        let (x, y) = mfc.imgPointToMfcLocation(imX: imX, imY: imY)
        displacement.templateX = Int32(x)
        displacement.templateY = Int32(y)
        displacement.templateWidth = Int32(width)
        displacement.templateHeight = Int32(height)
        self.width = width
        self.height = height
        timeZero = time
        self.updateWaypointAndLocation(time, waypoint: waypoint, x: x, y: y)
    }

}