//
//  DeviceConnector.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/14/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class DeviceConnector: BLEDelegate {
    
    var connected: Bool
    var ble: BLE
    let SCAN_TIMEOUT: Int = 3
    var connectionTimer: NSTimer?
    var scanTimer: NSTimer?
    var scanning: Bool
    var statusDelegates: [DeviceStatusDelegate]
    
    init() {
        connected = false
        scanning = false
        ble = BLE()
        ble.controlSetup()
        statusDelegates = []
        ble.delegate = self
    }
    
    func initiateContinuousScan() {
        NSTimer.scheduledTimerWithTimeInterval(Double(SCAN_TIMEOUT), target: self, selector: "scanTimer", userInfo: nil, repeats: true)
    }
    
    func scanTimer(timer: NSTimer) {
        if (connected) {
            timer.invalidate()
        } else {
            scanForPeripherals()
        }
    }
    
    func scanForPeripherals() {
        if (ble.activePeripheral != nil) {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
        
        scanning = true
        for delegate in statusDelegates {
            delegate.updateDeviceStatusScanning()
        }
        ble.peripherals = nil;
        ble.findBLEPeripherals(Int32(SCAN_TIMEOUT))
        scanning = false
        
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        scanTimer = NSTimer.scheduledTimerWithTimeInterval(Double(SCAN_TIMEOUT), target: self, selector: "bleFinishedScan", userInfo: nil, repeats: false)
        //connectionTimer = NSTimer.scheduledTimerWithTimeInterval(Double(TIMEOUT), target: self, selector: "connectToPeripheral", userInfo: nil, repeats: false)
    }
    
    @objc func bleFinishedScan() {
        for delegate in statusDelegates {
            delegate.updateDeviceStatusDisconnected()
        }
    }
    
    func connectToPeripheral(peripheral: CBPeripheral) {
        if (ble.activePeripheral != nil) {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        ble.connectPeripheral(peripheral)
        for delegate in statusDelegates {
            delegate.updateDeviceStatusConnecting(peripheral)
        }

    }
    
    func bleDidConnect() {
        connected = true
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        for delegate in statusDelegates {
            delegate.updateDeviceStatusConnected(ble.activePeripheral)
        }
    }
    
    func bleDidDisconnect() {
        connected = false
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        if scanning {
            for delegate in statusDelegates {
                delegate.updateDeviceStatusScanning()
            }
        } else {
            for delegate in statusDelegates {
                delegate.updateDeviceStatusDisconnected()
            }
        }
    }
    
    func bleDidReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int32) {
        
    }
    
    func bleSendData(buf: [Byte]) {
        var data = NSData(bytes: buf, length: buf.count)
        ble.write(data)
    }
    
    func bleSendData(data: NSData) {
        ble.write(data)
    }
    
    func countScannedPeripherals() -> Int {
        if (ble.peripherals != nil) {
            return ble.peripherals.count
        } else {
            return 0
        }
    }
    
    func getPeripheralAtIndex(index: Int) -> CBPeripheral? {
        if (ble.peripherals != nil && index < ble.peripherals.count) {
            return ble.peripherals.objectAtIndex(index) as? CBPeripheral
        } else {
            return nil
        }
    }
    
    func addDelegate(delegate: DeviceStatusDelegate) {
        statusDelegates.append(delegate)
    }
}

protocol DeviceStatusDelegate {
    func updateDeviceStatusScanning()
    func updateDeviceStatusDisconnected()
    func updateDeviceStatusConnecting(peripheral: CBPeripheral)
    func updateDeviceStatusConnected(peripheral: CBPeripheral)
}