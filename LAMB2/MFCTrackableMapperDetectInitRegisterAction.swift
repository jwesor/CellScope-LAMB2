//
//  MFCTrackableMapperDetectInitRegisterAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/23/16.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackableMapperDetectInitRegisterAction: SequenceAction {

    let mfc: MFCSystem
    let mapper: MFCTrackableMapper
    let waypoint: MFCWaypoint
    private let detectAction: MFCTrackableDetectAction

    init(mapper: MFCTrackableMapper, waypoint: MFCWaypoint) {
        self.mapper = mapper
        self.waypoint = waypoint
        self.mfc = mapper.mfc

        detectAction = MFCTrackableDetectAction(mfc: MFCSystem)

        super.init([detectAction])
    }

    override func onActionCompleted(action: AbstractAction) {
        if (action == detectAction) {
            // Register stuff
            var trackables = detectAction.detectedTrackables
            var params = detectAction.trackableParams

            var trackablesToInit = []
            var paramsToInit = []
            for (i, trackable) in trackables.enumerate() {
                if !mapper.isRedundantTrackable(params[i]) {
                    trackablesToInit.append(trackable)
                    paramsToInit.append(params[i])
                    mapper.registerTrackable(trackable, waypoint: waypoint)
                }
            }

            let batchInitAction = MFCTrackableBatchInitAction(waypoint: waypoint, trackables: trackablesToInit, params: paramsToInit)
            self.addOneTimeAction(batchInitAction)
        }
    }

}