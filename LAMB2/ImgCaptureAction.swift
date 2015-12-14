//
//  ImgCaptureAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/23/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImgCaptureAction : ImageProcessorAction {
    
    let capture: IPImageCapture
    
    convenience init(camera: CameraSession, writer: ImageFileWriter) {
        let capture = IPImageCapture.initWithWriter(writer)
        self.init(camera: camera, capture: capture)
    }
    
    init(camera: CameraSession, capture: IPImageCapture) {
        self.capture = capture
        super.init([capture], standby: 1, camera: camera)
    }
    
}