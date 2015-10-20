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

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        super.init(mfc: waypoint.mfc, displace: waypoint.displacement, preprocessors: waypoint.preprocessors, updateMfc: true)
    }

    override func cleanup() {
        super.cleanup()
        waypoint.applyDisplacement(dX: self.dX, dY: self.dY)
        waypoint.mfc.setCurrentPosition(x: waypoint.x, y: waypoint.y)
    }

}