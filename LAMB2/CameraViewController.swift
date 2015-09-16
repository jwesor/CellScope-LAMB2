//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class CameraViewController: UIViewController {
    
    @IBOutlet weak var gdriveButton: GDriveStatusButton!
    @IBOutlet weak var debugText: UITextView!
    @IBOutlet weak var stepText: UITextField!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var deviceButton: DeviceStatusButton!
    
    var session: CameraSession?
    var device: DeviceConnector = DeviceConnector()
    var queue: ActionManager = ActionQueue()
    let stage: StageState = StageState()
    var autofocus: AutofocuserAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DebugUtil.debugView = debugText
        DebugUtil.log("initializing...")
        
        session = CameraSession.initWithPreview(preview)
        session?.continuousAutoFocus = false
        session?.continuousAutoWhiteBalance = false
        session?.continuousAutoExposure = false
        session?.startCameraSession()
        
        device.addStatusDelegate(deviceButton)
        deviceButton.updateDeviceStatusDisconnected()
        
        queue.beginActions()
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyyMMddHHmm"
        let datestring = dateFormat.stringFromDate(NSDate())
        let directory = DocumentDirectory("lamb2_\(datestring)")
        
        autofocus = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera: session!, device: device, stage: stage)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listBLEDevices") {
            device.scanForPeripherals()
            var table = segue.destinationViewController as! DeviceTableViewController
            table.device = device
        }
    }
    
    @IBAction func test(sender: AnyObject) {
        queue.addAction(AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera:session!, device: device, stage: stage));
    }
    
    @IBAction func test2(send: AnyObject) {
    }
    
    @IBAction func test3(sender: AnyObject) {
    }
    
    @IBAction func microstep(sender: AnyObject) {
        let text = sender.currentTitle!!
        let toggle = text.rangeOfString("True") != nil
        
        queue.addAction(StageMicrostepAction(device, enabled: toggle, stage: stage))
    }

    @IBAction func balance(sender: AnyObject) {
        queue.addAction(CameraAutoWhiteBalanceAction(camera: session!))
        let exp = CameraAutoExposureAction(camera: session!)
        exp.timeout = 3
        queue.addAction(exp)
        queue.addAction(CameraAutoFocusAction(camera: session!))
    }
    
    @IBAction func moveXPlus(sender: AnyObject) {
        var steps = stepText.text.toInt()!
        
        var text = sender.currentTitle!!
        var motor: Int
        var dir: Bool
        
        if (text.rangeOfString("y") != nil) {
            motor = StageConstants.MOTOR_1
        } else if (text.rangeOfString("x") != nil) {
            motor = StageConstants.MOTOR_2
        } else {
            motor = StageConstants.MOTOR_3
        }
        
        if (text.rangeOfString("+") != nil) {
            dir = StageConstants.DIR_HIGH
        } else {
            dir = StageConstants.DIR_LOW
        }
        queue.addAction(StageEnableStepAction(device, motor: motor, dir: dir, steps:steps, stage: stage))
    }
    
    @IBAction func led2off(sender: AnyObject) {
        device.bleSendData([0x27, 0, 0])
    }
    
    @IBAction func led2on(sender: AnyObject) {
        device.bleSendData([0x28, 0, 0])
    }
    
    @IBAction func led1off(sender: AnyObject) {
        device.bleSendData([0x25, 0, 0])
    }
    
    @IBAction func led1on(sender: AnyObject) {
        device.bleSendData([0x26, 0, 0])
    }
}
