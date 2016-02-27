//
//  MFCTrackableMapHistory.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/26/16.
//  Copyright © 2016 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableMapHistory {
    
    unowned let trackable: MFCTrackable
    private(set) var timeZero: NSDate?
    private(set) var timestamps: [NSTimeInterval] = []
    private(set) var positions: [(x: Int, y: Int)] = []
    private(set) var waypoints: [MFCWaypoint?] = []
    
    init(trackable: MFCTrackable) {
        self.trackable = trackable
    }
    
    func setStartTime(time: NSDate) {
        timeZero = time
    }
    
    func update(position: (x: Int, y: Int), time: NSDate, waypoint: MFCWaypoint? = nil) {
        let timeInterval = (timeZero != nil) ? time.timeIntervalSinceDate(timeZero!) : time.timeIntervalSince1970
        timestamps.append(timeInterval)
        positions.append(position)
        waypoints.append(waypoint)
    }
    
    func update(time: NSDate, waypoint: MFCWaypoint? = nil) {
        self.update((x: trackable.x, y: trackable.y), time: time, waypoint: waypoint)
    }
    
}