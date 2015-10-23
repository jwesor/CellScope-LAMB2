//
//  MFCWaypointMoveToAction
//  LAMB2
//
//  Attempts to move the MFC as close as possible to a given waypoint.
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypointMoveToAction : SequenceAction {

    private let mfc: MFCSystem
    let waypoint: MFCWaypoint
    private let displacementAction: MFCWaypointDisplacementAction
    private var initialMove: Bool = false

    init(waypoint: MFCWaypoint) {
        self.waypoint = waypoint
        self.mfc = waypoint.mfc
        displacementAction = MFCWaypointDisplacementAction(waypoint: waypoint, updateMfc: true)
        super.init()
    }

    override func doExecution() {
        initialMove = true
        print("inital move to \((waypoint.x, waypoint.y))")
        let approxMove = MFCMoveToAction(mfc: mfc, x: waypoint.x, y: waypoint.y, stride: 0)
        addOneTimeActions([approxMove, mfc.autofocuser, displacementAction])
        super.doExecution()
    }

    override func onActionCompleted(action: AbstractAction) {
        if action === displacementAction && initialMove {
            initialMove = false
            let dX = -displacementAction.dX, dY = -displacementAction.dY //Offset to the waypoint
            print("precise move by \((dX, dY))")
            let preciseMove = MFCMoveAction(mfc: mfc, dX: dX, dY: dY, stride: 0)
            //TODO: Could make this even more precise by setting distance tolerance based on the step being taken
            addOneTimeActions([preciseMove, displacementAction])
        }
    }
}