//
//  MFCWaypointInitAction
//  LAMB2
//
//  Initialize a waypoint at the current position.
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypointInitAction : MFCDisplacementAction {

    let waypoint: MFCWaypoint
    let updateMfc: Bool

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        super.init(mfc: mfc, displace: waypoint.displacement, preprocessors: waypoints.preprocessors, updateMfc: true)
    }

    override func doExecution() {
        waypoint.displacement.reset()
        super.doExecution()
    }

    override func cleanup() {
        super.cleanup()
        waypoint.setCurrentPosition(x: mfc.x, y: mfc.y)
    }

}