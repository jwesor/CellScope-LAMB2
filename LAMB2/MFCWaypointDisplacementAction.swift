//
//  MFCWaypointDisplacementAction
//  LAMB2
//
//  Get the displacement relative to the specified waypoint.
//  If updateMfc is true, then the MFC's current position is
//  set based on the waypoint's position and calculated displacement.
//  
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypointDisplacementAction : MFCDisplacementAction {

    let waypoint: MFCWaypoint
    let updateMfc: Bool

    init(waypoint: MFCWaypoint, updateMfc: Bool) {
        self.waypoint = waypoint
        self.updateMfc = updateMfc
        super.init(mfc: mfc, displace: waypoint.displacement, preprocessors: waypoints.preprocessors, updateMfc: false)
    }

    override func cleanup() {
        super.cleanup()
        if updateMfc {
            waypoint.mfc.setCurrentPosition(x: x + self.dX, y: y + self.dY)
        }
    }

}