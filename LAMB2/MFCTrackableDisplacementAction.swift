//
//  MFCTrackableDisplacementAction.swift
//  LAMB2
//
//  Find how much the trackable has moved by
//
//  Created by Fletcher Lab Mac Mini on 2/26/16.
//  Copyright © 2016 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDisplacementAction : ImageProcessorAction {
    
    let trackable: MFCTrackable
    let mfc: MFCSystem
    var updateFrame: Bool = false // Update the snapshot of the trackable?
    var searchWidth, searchHeight: Int
    private(set) var inFov: Bool = false
    
    init(trackable: MFCTrackable, searchWidth: Int = 0, searchHeight: Int = 0) {
        self.trackable = trackable
        self.mfc = trackable.mfc
        self.searchWidth = searchWidth
        self.searchHeight = searchHeight
        super.init([trackable.displacement], standby: 0, camera: mfc.camera, stage: mfc.stage)
    }
    
    convenience init(trackable: MFCTrackable, searchSize: Int) {
        self.init(trackable: trackable, searchWidth: searchSize, searchHeight: searchSize)
    }
    
    override func doExecution() {
        let (imX, imY) = mfc.mfcLocationToImgPoint(x: trackable.x, y: trackable.y)
        let (fovWidth, fovHeight) = mfc.stage.getFovDimens()
        if imX >= 0 && imY >= 0 && imX + trackable.width < fovWidth && imY + trackable.height < fovHeight {
            if searchWidth <= 0 || searchHeight <= 0 {
                trackable.displacement.roi = false
                trackable.displacement.templateX = Int32(imX)
                trackable.displacement.templateY = Int32(imY)
            } else {
                trackable.displacement.roi = true
                let roiX = Int32(max(0, imX - searchWidth / 2))
                let roiY = Int32(max(0, imY - searchHeight / 2))
                trackable.displacement.roiX = roiX
                trackable.displacement.roiY = roiY
                trackable.displacement.roiWidth = Int32(trackable.width + searchWidth)
                trackable.displacement.roiHeight = Int32(trackable.height + searchHeight)
                trackable.displacement.templateX = Int32(imX) - roiX
                trackable.displacement.templateY = Int32(imY) - roiY
            }
            inFov = true
            trackable.displacement.updateTemplate = updateFrame
            super.doExecution()
        } else {
            inFov = false
            finish()
        }
    }
    
}