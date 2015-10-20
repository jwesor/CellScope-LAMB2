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
    let updateMfcToWaypoint: Bool

    init(waypoint: MFCWaypoint, updateMfc: Bool) {
        self.waypoint = waypoint
        self.updateMfcToWaypoint = updateMfc
        super.init(mfc: waypoint.mfc, displace: waypoint.displacement, preprocessors: waypoint.preprocessors, updateMfc: false)
    }

    override func cleanup() {
        super.cleanup()
        if updateMfcToWaypoint {
            waypoint.mfc.setCurrentPosition(x: waypoint.x + self.dX, y: waypoint.y + self.dY)
        }
    }

}