//
//  MFCSystem.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCSystem: ActionCompletionDelegate {
    
    let stage: StageState
    let camera: CameraSession
    let device: DeviceConnector
    let displace: IPDisplacement
    let bounds: IPFovBounds
    let initAct: AbstractAction
    var x: Int
    var y: Int
    
    init(camera: CameraSession, device: DeviceConnector, stage: StageState) {
        self.camera = camera
        self.stage = stage
        self.device = device
        
        displace = IPDisplacement()
        displace.enabled = false
        bounds = IPFovBounds()
        bounds.enabled = false
        x = 0
        y = 0
        initAct = ImageProcessorAction([bounds], camera: camera)
        initAct.addCompletionDelegate(self)
    }
    
    func reset() {
        x = 0
        y = 0
        displace.cropX = bounds.x
        displace.cropY = bounds.y
        displace.cropWidth = bounds.width
        displace.cropHeight = bounds.height
    }
    
    func onActionCompleted(action: AbstractAction) {
        if action == initAct {
            reset()
        }
    }
}