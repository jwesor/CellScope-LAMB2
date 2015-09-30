
//
//  DeviceStatusDelegate.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/30/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol DeviceStatusDelegate {
    func updateDeviceStatusScanning()
    func updateDeviceStatusDisconnected()
    func updateDeviceStatusConnecting(peripheral: CBPeripheral)
    func updateDeviceStatusConnected(peripheral: CBPeripheral)
    func updateDeviceStatusReady()
}