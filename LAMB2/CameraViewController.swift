//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var preview: UIImageView!
    var session:CameraSession?
    var device:DeviceConnector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = CameraSession.initWithPreview(preview)
        session?.startCameraSession()
        device = DeviceConnector()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        device?.scanForPeripherals()
        if (segue.identifier == "listBLEDevices") {
            var table = segue.destinationViewController as DeviceTableViewController
            table.device = device
        }
    }
    
//    @IBAction func onScanButtonClick(sender: AnyObject) {
//        device?.scanForPeripherals()
//    }
}
