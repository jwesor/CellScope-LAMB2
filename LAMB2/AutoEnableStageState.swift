//
//  AutoEnableStageState.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/30/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation
import CoreBluetooth

class AutoEnableStageState : StageState, DeviceStatusDelegate {
    
    private var device: DeviceConnector?
    private var actions: ActionManager?
    
    override init() {
        super.init()
    }
    
    init(device: DeviceConnector, actions: ActionManager) {
        super.init()
        self.autoEnableOnConnection(device, actions: actions)
    }
    
    func autoEnableOnConnection(device: DeviceConnector, actions: ActionManager) {
        self.device = device
        self.actions = actions
        device.addStatusDelegate(self)
    }
    
    func updateDeviceStatusDisconnected() {
        resetAll()
    }
    
    func updateDeviceStatusReady() {
        let en1 = StageEnableAction(device!, motor: StageConstants.MOTOR_1, stage: self)
        let en2 = StageEnableAction(device!, motor: StageConstants.MOTOR_2, stage: self)
        actions?.addAction(en1)
        actions?.addAction(en2)
    }
    
    func updateDeviceStatusConnected(peripheral: CBPeripheral) {}
    
    func updateDeviceStatusConnecting(peripheral: CBPeripheral) {}
    
    func updateDeviceStatusScanning() {}
}