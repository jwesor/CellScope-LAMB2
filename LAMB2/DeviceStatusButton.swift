//
//  DeviceStatusButton.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/21/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//


class DeviceStatusButton: UIButton, DeviceStatusDelegate {
    
    func updateDeviceStatusScanning() {
        self.setTitle("Scanning...", forState: UIControlState.Normal)
    }
    
    func updateDeviceStatusDisconnected() {
        self.setTitle("Disconnected", forState: UIControlState.Normal)
    }
    
    func updateDeviceStatusConnecting(peripheral: CBPeripheral) {
        self.setTitle("Scanning...", forState: UIControlState.Normal)
    }
    
    func updateDeviceStatusConnected(peripheral: CBPeripheral) {
        self.setTitle("Connected to \(peripheral.name) : \(peripheral.identifier.UUIDString)", forState: UIControlState.Normal)
    }
}