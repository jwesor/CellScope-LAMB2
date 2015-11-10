//
//  ImgDisplacementAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImgDisplacementAction: ImageProcessorAction {
    
    let displacement: IPDisplacement
    private(set) var dX: Int = 0
    private(set) var dY: Int = 0
    
    init(camera: CameraSession, displace: IPDisplacement? = nil, preprocessors: [ImageProcessor] = []) {
        self.displacement = (displace == nil) ? IPDisplacement() : displace!
        super.init(preprocessors + [self.displacement], standby: 0, camera: camera)
    }
    
    override func cleanup() {
        super.cleanup()
        dX = Int(displacement.dX)
        dY = Int(displacement.dY)
    }

    func reset() {
        displacement.reset()
    }

}