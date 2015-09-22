//
//  DeviceConnector.swift
//  LAMB2
//
//  Handles operations for scanning, connecting to, and communicating
//  with a BLE device.
//
//  Created by Fletcher Lab Mac Mini on 1/14/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//


import Foundation
import CoreBluetooth

class DeviceConnector: BLEDelegate {
    
    private(set) var connected: Bool
    var ble: BLE
    let SCAN_TIMEOUT: Double = 3
    private var tentativePeripheral: CBPeripheral? = nil
    private var activePeripheral: CBPeripheral? = nil
    var statusDelegates: [DeviceStatusDelegate]
    var dataDelegates: [String: DeviceDataDelegate]
    
    init() {
        connected = false
        ble = BLE()
        statusDelegates = []
        dataDelegates = Dictionary<String, DeviceDataDelegate>()
        ble.delegate = self
    }
    
    func scanForPeripherals() {
        disconnect()
        for delegate in statusDelegates {
            delegate.updateDeviceStatusScanning()
        }
        ble.startScanning(SCAN_TIMEOUT)
    }
    
    func bleFinishedScan() {
        for delegate in statusDelegates {
            delegate.updateDeviceStatusDisconnected()
        }
    }
    
    func connect(peripheral: CBPeripheral) {
        tentativePeripheral = peripheral
        ble.connectToPeripheral(peripheral)
    }
    
    func disconnect() {
        if connected {
            ble.disconnectFromPeripheral(activePeripheral!)
        }
    }
    
    func bleDidConnectToPeripheral() {
        connected = true
        activePeripheral = tentativePeripheral
        for delegate in statusDelegates {
            delegate.updateDeviceStatusConnected(activePeripheral!)
        }
    }
    
    func bleDidUpdateState() {
        
    }
    
    func bleDidDisconnectFromPeripheral() {
        connected = false
        for delegate in statusDelegates {
            delegate.updateDeviceStatusDisconnected()
        }
    }
    
    func bleDidReceiveData(data: NSData?) {
//        DebugUtil.log(String(format: "received: %d\n", result))
        if data != nil {
            for (_, delegate) in dataDelegates {
                delegate.deviceDidReceiveData(data!)
            }
        }
    }
    
    func getPeripherals() -> [CBPeripheral] {
        return ble.peripherals
    }
    
    func send(buf: [UInt8]) {
        let data = NSData(bytes: buf, length: buf.count)
        //        DebugUtil.log(String(format: "send: %@\n", data))
        ble.write(data: data)
    }
    
    func send(data: NSData) {
        //        DebugUtil.log(String(format: "send: %@\n", data))
        ble.write(data: data)
    }
    
    func addStatusDelegate(delegate: DeviceStatusDelegate) {
        statusDelegates.append(delegate)
    }
    
    func addDataDelegate(delegate: DeviceDataDelegate, id: String) {
        dataDelegates[id] = delegate
    }
    
    func removeDataDelegate(id: String) {
        dataDelegates[id] = nil
    }
}

protocol DeviceStatusDelegate {
    func updateDeviceStatusScanning()
    func updateDeviceStatusDisconnected()
    func updateDeviceStatusConnecting(peripheral: CBPeripheral)
    func updateDeviceStatusConnected(peripheral: CBPeripheral)
}

protocol DeviceDataDelegate {
    func deviceDidReceiveData(data:NSData)
}