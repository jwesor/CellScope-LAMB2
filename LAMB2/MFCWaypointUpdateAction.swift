//
//  MFCWaypointUpdateAction
//  LAMB2
//
//  Updates the waypoint's underlying image processor to a new frame
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypointUpdateAction : MFCDisplacementAction {

    let waypoint: MFCWaypoint

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        super.init(mfc: waypoint.mfc, displace: waypoint.displacement, preprocessors: waypoint.preprocessors, updateMfc: false)
    }

    override func doExecution() {
        let originX = Int(waypoint.displacement.templateX)
        let originY = Int(waypoint.displacement.templateY)
        waypoint.displacement.centerTemplate = false
        let offsetX = waypoint.x - waypoint.mfc.x
        let offsetY = waypoint.y - waypoint.mfc.y
        waypoint.displacement.templateX = Int32(originX + offsetX)
        waypoint.displacement.templateY = Int32(originY + offsetY)
        waypoint.displacement.reset()
        super.doExecution()
    }

    override func cleanup() {
        super.cleanup()
        waypoint.displacement.centerTemplate = true
    }

}