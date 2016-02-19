//
//  MFCTrackableDetectionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDetectionAction : ImageProcessorAction {
   
    let mfc: MFCSystem
    let detector: IPDetectContourTrackables = IPDetectContourTrackables()
    private(set) var detectedTrackables: [MFCTrackable] = []
    private(set) var trackableParams: [(imX: Int, imY: Int, width: Int, height: Int)] = []
   
    init(mfc: MFCSystem) {
        self.mfc = mfc
        super.init([detector], standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        detectedTrackables = []
        trackableParams = []
        super.doExecution()
    }

    override func cleanup() {
        let counts = detector.detectedCount
        for i in 0...counts-1 {
            let trackable = MFCTrackable(mfc: self.mfc)
            let result = detector.getDetectedTrackable(i)
            let x = Int(result.x), y = Int(result.y), width = Int(result.width), height = Int(result.height)
            detectedTrackables.append(trackable)
            trackableParams.append((imX: x, imY: y, width: width, height: height))
        }
    }

}