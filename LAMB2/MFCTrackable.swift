//
//  MFCTrackable.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackable {
    
    let waypoint: MFCWaypoint
//    let imgproc: ImageProcessor
    private(set) var x: Int = 0, y: Int = 0
    
    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
    }
    
    func setLocation(x x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func applyDisplacement(dX dX: Int, dY: Int) {
        x += dX
        y += dY
    }
    
}