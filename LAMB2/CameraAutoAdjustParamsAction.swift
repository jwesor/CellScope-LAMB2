
//
//  CameraAutoAdjustParamsAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/13/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class CameraAutoAdjustParamsAction: SequenceAction {
    
    init(camera: CameraSessionProtocol) {
        let exposure = CameraAutoExposureAction(camera)
        let balance = CameraAutoWhiteBalanceAction(camera)
        let autofocus = CameraAutoFocusAction(camera)
        super.init([exposure, balance, autofocus])
    }
    
}