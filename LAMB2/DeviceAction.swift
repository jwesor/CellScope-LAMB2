//
//  DeviceAction.swift
//  LAMB2
//
//  Action that sends data to a connected device and waits
//  for a response.
//
//  Created by Fletcher Lab Mac Mini on 2/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class DeviceAction: AbstractAction, DeviceDataDelegate {
    
    var device:DeviceConnector
    var id:String
    var data:[Byte]
    
    init(dc:DeviceConnector, id:String, data:[Byte]) {
        self.device = dc
        self.id = id
        self.data = data
        super.init()
    }
    
    override func doExecution() {
        if !device.connected {
            finish()
        } else {
            device.addDataDelegate(self, id:id)
            device.bleSendData(data)
        }
    }
    
    func deviceDidReceiveData(data:UInt8) {
        //sleep(1)
        NSLog("received %d %@", data, id)
        device.removeDataDelegate(id)
        finish()
    }
    
}