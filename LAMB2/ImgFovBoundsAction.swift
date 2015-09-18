//
//  ImgFovBoundsAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/18/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImgFovBoundsAction: ImageProcessorAction {
    
    let stage: StageState
    let fov: IPFovBounds
    var ipBoundRois: [ImageProcessor]
    
    init(camera: CameraSession, stage: StageState, bindRois: [ImageProcessor] = [], fov: IPFovBounds? = nil) {
        self.stage = stage
        self.fov = (fov == nil) ? IPFovBounds() : fov!
        self.ipBoundRois = bindRois
        super.init([self.fov], camera: camera)
    }
    
    func bindImageProcesosrRoi(imgproc: ImageProcessor) {
        ipBoundRois.append(imgproc)
    }
    
    func bindImageProcessorRoi(imgprocAction: ImageProcessorAction) {
        ipBoundRois.append(imgprocAction.proc)
    }
    
    override func cleanup() {
        stage.setFovBounds(fov.x, y: fov.y, width: fov.width, height: fov.height)
        for imgproc in ipBoundRois {
            fov.setBoundsAsRoi(imgproc)
            imgproc.roi = true
        }
        super.cleanup()
    }
}