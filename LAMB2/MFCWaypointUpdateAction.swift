//
//  MFCWaypointUpdateAction
//  LAMB2
//
//  Finds the displacement from the current position to the waypoint, then moves the 
//  waypoint to the current position.
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypointUpdateAction : MFCDisplacementAction {

    let waypoint: MFCWaypoint
    let updateMfc: Bool

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        super.init(mfc: mfc, displace: waypoint.displacement, preprocessors: waypoints.preprocessors, updateMfc: true)
    }

    override func cleanup() {
        super.cleanup()
        waypoint.applyDisplacement(dX: self.dX, dY: self.DY)
        waypoint.mfc.setCurrentPosition(x: waypoint.x, y: waypoint.y)
    }

}