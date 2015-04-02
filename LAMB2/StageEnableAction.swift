//
//  StageEnableAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class StageEnableAction : DeviceAction {

    init(_ device: DeviceConnector, motor: Int) {
        let code = StageEnableAction.getEnableCode(motor)
        super.init(device, id: "stage_enable", data: [code, 0x0, 0x0])
    }
    
    class func getEnableCode(motor: Int) -> Byte {
        let disCode = StageDisableAction.getDisableCode(motor)
        if (disCode != 0) {
            return disCode | 0x10
        } else {
            return 0x0
        }
    }
}