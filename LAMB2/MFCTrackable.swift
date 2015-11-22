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
    
    init(x: Int = 0, y: Int = 0) {
        diplacement = IPDisplacement()
        displacement.updateTemplate = true
        displacement.centerTemplate = false
        displacement.trackTemplate = true
        self.x = x
        self.y = y
    }

    func setLocation(x x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func initRelativeToWaypoint(waypoint: MFCWaypoint, imX: Int, imY: Int, width: Int, height: Int) {
        self.waypoint = waypoint
        (x, y) = waypoint.mfc = mfc.imgPointToMfcLocation(imX: imX, imY: imY)
        displacement.templateX = Int32(x)
        displacement.templateY = Int32(y)
        displacement.templateWidth = Int32(width)
        displacement.templateHeight = Int32(height)
    }

    func applyDisplacement(dX dX: Int, dY: Int) {
        x += dX
        y += dY
    }

    func getImageProcessors() -> [ImageProcessor] {
        return [displacement]
    }

}