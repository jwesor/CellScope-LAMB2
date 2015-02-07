//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var deviceButton: DeviceStatusButton!
    var session: CameraSession?
    var device: DeviceConnector?
    var touch: TouchStagePan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = CameraSession.initWithPreview(preview)
        session?.startCameraSession()
        device = DeviceConnector()
        device?.addStatusDelegate(deviceButton)
        deviceButton.updateDeviceStatusDisconnected()
        touch = TouchStagePan(view: preview, device: device!)
        
        let tracker = IPPanTracker();
        session?.addImageProcessor(tracker);
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
    
    @IBAction func test(sender: AnyObject) {
        var sequence = ActionSequencer()
//        var seq = SequenceAction()
//        seq.addSubAction(DeviceAction(dc: device!, id: "a", data: [0x04, 0x0, 0x0]))
//        seq.addSubAction(DeviceAction(dc: device!, id: "b", data: [0x14, 0x0, 0x0]))
//        seq.addSubAction(DeviceAction(dc: device!, id: "c", data: [0x04, 0x0, 0x0]))
//        seq.addSubAction(DeviceAction(dc: device!, id: "d", data: [0x14, 0x0, 0x0]))
//        seq.addSubAction(DeviceAction(dc: device!, id: "e", data: [0x04, 0x0, 0x0]))
//        sequence.addAction(seq)
        sequence.addAction(StageEngageStepAction(dc: device!, motor: StageEngageStepAction.MOTOR_1, dir: StageEngageStepAction.DIR_HIGH, steps: 2500))
        sequence.executeSequence()
    }
    

}
