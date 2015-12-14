//
//  ImgAcquireBackgroundAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/16/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImgAcquireBackgroundAction : ImageProcessorAction {
    
    let background: IPBackgroundSubtract
    
    init(camera: CvCameraSession, ipBackground: IPBackgroundSubtract? = nil) {
        background = (ipBackground == nil) ? IPBackgroundSubtract() : ipBackground!
        super.init([self.background], camera: camera)
    }
    
    override func doExecution() {
        background.reset()
        super.doExecution()
    }
    
}