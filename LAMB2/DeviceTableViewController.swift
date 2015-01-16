//
//  DeviceTableViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/15/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import UIKit

class DeviceTableViewController: UITableViewController {

    var device: DeviceConnector?
    var updateTimer: NSTimer?
    let UPDATE_INTERVAL: Double = 1
    var updates: Int?
    
    override func viewDidLoad() {
        device?.scanForPeripherals()
        updates = 0
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(UPDATE_INTERVAL, target: self, selector: "updateDeviceList", userInfo: nil, repeats: true)    }
    
    func updateDeviceList() {
        NSLog("Updating")
        updates? += 1
        var max:Double = Double(device!.SCAN_TIMEOUT) / UPDATE_INTERVAL
        if (Double(updates!) > max && updateTimer? != nil) {
            updateTimer?.invalidate()
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return device!.countScannedPeripherals()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DeviceListPrototypeCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = device?.getPeripheralLabelAtIndex(indexPath.row)
        return cell
    }
}
