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
    var connected: Bool
    var id:String
    var data:[UInt8]
    
    init(_ dc:DeviceConnector, id:String, data:[UInt8]) {
        self.device = dc
        self.id = id
        self.data = data
        self.connected = false
        super.init()
    }
    
    override func doExecution() {
        connected = device.connected
        if !connected {
            finish()
        } else {
            device.addDataDelegate(self, id:id)
            device.bleSendData(data)
        }
    }
    
    func deviceDidReceiveData(data:UInt8) {
        finish()
    }
    
    override func cleanup() {
        if device.connected {
            device.removeDataDelegate(id)
        }
    }
    
}