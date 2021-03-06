//
//  DeviceTableViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/15/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//


import Foundation
import CoreBluetooth

class DeviceTableViewController: UITableViewController {

    var device: DeviceConnector?
    var updateTimer: NSTimer?
    let UPDATE_INTERVAL: Double = 0.5
    var updates: Int?
    var peripherals: Dictionary<String, CBPeripheral> = [String: CBPeripheral]()
    
    override func viewDidLoad() {
        device?.scanForPeripherals()
        updates = 0
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(UPDATE_INTERVAL, target: self, selector: "updateDeviceList", userInfo: nil, repeats: true)
    }
    
    func updateDeviceList() {
        NSLog("Updating")
        updates? += 1
        let max:Double = Double(device!.SCAN_TIMEOUT) / UPDATE_INTERVAL
        if (Double(updates!) > max && updateTimer != nil) {
            updateTimer?.invalidate()
            
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return device!.getPeripherals().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceListPrototypeCell", forIndexPath: indexPath) 
        let button = cell.contentView.viewWithTag(1) as! UIButton
        let peripheral = device!.getPeripherals()[indexPath.row]
        let label = "\(peripheral.name!) : \(peripheral.identifier.UUIDString)"
        button.setTitle(label, forState: UIControlState.Normal)
        peripherals[label] = peripheral
        button.enabled = true
        return cell
    }
    
    @IBAction func onDeviceButtonPressed(sender: AnyObject) {
        let button = sender as! UIButton
        let label = button.titleLabel!.text!
        NSLog(peripherals[label]!.identifier.UUIDString)
        device?.connect(peripherals[label]!)
    }
}
