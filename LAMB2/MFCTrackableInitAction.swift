//
//  MFCTrackableInitAction.swift
//  LAMB2
//
//  Initialize a trackable with the given on-screen coordinates and dimensions
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableInitAction : ImageProcessorAction {

    let trackable: MFCTrackable
    private let imX: Int, imY: Int, width: Int, height: Int

    init(trackable: MFCTrackable, imX: Int, imY: Int, width: Int, height: Int) {
        self.imX = imX
        self.imY = imY
        self.width = width
        self.height = height
        self.trackable = trackable
        let mfc = trackable.mfc
        super.init([trackable.displacement], standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        trackable.width = width
        trackable.height = height
        trackable.displacement.roi = false
        trackable.displacement.centerTemplate = false
        trackable.displacement.templateX = Int32(imX)
        trackable.displacement.templateY = Int32(imY)
        trackable.displacement.templateWidth = Int32(width)
        trackable.displacement.templateHeight = Int32(width)
        trackable.displacement.reset()
        super.doExecution()
    }
    
    override func cleanup() {
        trackable.initAtImageLocation((imX: imX, imY: imY), width: width, height: height)
    }

}