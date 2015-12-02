//
//  MFCTrackableDetectionAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackableDetectionAction : ImageProcessorAction {
   
    let detector: IPDetectContourTrackables = IPDetectContourTrackables()
    private(set) var detectedTrackables: [MFCTrackable : (imX: Int, imY: Int, width: Int, height: Int)] = [:]
   
    init() {
        super.init([detector], standby: 0, camera: mfc.camera, stage: mfc.stage)
    }

    override func doExecution() {
        detectedTrackables = [:]
        super.doExecution()
    }

    override func cleanup() {
        let counts = processor.detectedCount
        for i in 0...counts-1 {
            let trackable = MFCTrackable()
            let result = detector.getDetectedTrackable(i)
            let x = Int(result.x), y = Int(result.y), width = Int(result.width), height = Int(result.height)
             detectedTrackables[trackable] = (x: imX, y: imY, width: width, height: height)
        }
    }

}