//
//  MFCTrackable.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackable {
    
    private(set) var initalized: Bool = false
    private(set) var waypoint: MFCWaypoint?
    let mfc: MFCSystem
    let mapper: MFCTrackableMapper
    let displacement: IPDisplacement = IPPyramidDisplacement()
    private(set) var width: Int, height: Int
    private(set) var x: Int, y: Int
    private(set) var timeZero: NSDate?
    private var timestamps: [NSTimeInterval] = []
    private var positions: [(x: Int, y: Int)] = []
    private var waypoints: [MFCWaypoint] = []
    private var updateDelegates: [MFCTrackableUpdatedDelegate] = []
    var recordHistory: Bool = true
    
    init(mapper: MFCTrackableMapper, x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0) {
        self.mfc = mapper.mfc
        self.mapper = mapper
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
        for delegate in updateDelegates {
            delegate.onTrackableUpdated(self)
        }
    }

    func updateWaypointAndLocation(time: NSDate, waypoint: MFCWaypoint, x: Int, y: Int) {
        updateLocation(time, x: x, y: y)
        if self.recordHistory {
            waypoints.append(waypoint)
        }
        for delegate in updateDelegates {
            delegate.onTrackableUpdated(self)
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
        for delegate in updateDelegates {
            delegate.onTrackableInitialized(self)
        }
        initalized = true
        mapper.registerTrackable(self, waypoint: waypoint)
    }

    func addUpdateDelegate(delegate: MFCTrackableUpdatedDelegate) {
        updateDelegates.append(delegate)
    }
}

protocol MFCTrackableUpdatedDelegate {
    func onTrackableInitialized(trackable: MFCTrackable)
    func onTrackableUpdated(trackable: MFCTrackable)
}