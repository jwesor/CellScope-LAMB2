//
//  MFCTrackablePositionUpdateAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackablePositionUpdateAction : ImageProcessorAction {
    
    let trackable: MFCTrackable
    let mfc: MFCSystem
    private(set) var inFov: Bool = false
    
	init(trackable: MFCTrackable) {
        self.trackable = trackable
        self.mfc = trackable.mfc
        super.init([trackable.displacement], standby: 0, camera: mfc.camera, stage: mfc.stage)
	}
    
    override func doExecution() {
        let (imX, imY) = mfc.mfcLocationToImgPoint(x: trackable.x, y: trackable.y)
        let (fovWidth, fovHeight) = mfc.stage.getFovDimens()
        if imX >= 0 && imY >= 0 && imX + trackable.width < fovWidth && imY + trackable.height < fovHeight {
            trackable.displacement.templateX = Int32(imX)
            trackable.displacement.templateY = Int32(imY)
            inFov = true
            super.doExecution()
        } else {
            inFov = false
            finish()
        }
    }
}