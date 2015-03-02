//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class CameraViewController: UIViewController {
    
    @IBOutlet weak var stepText: UITextField!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var deviceButton: DeviceStatusButton!
    var session: CameraSession?
    var device: DeviceConnector?
    var touch: TouchStagePan?
    var state:Bool = false
    var sequence:ActionManager?
    var album:PhotoAlbum?
    
    var multi:AsyncImageMultiProcessor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = CameraSession.initWithPreview(preview)
        
        device = DeviceConnector()
        device?.addStatusDelegate(deviceButton)
        deviceButton.updateDeviceStatusDisconnected()
        touch = TouchStagePan(view: preview, device: device!)
        
        album = PhotoAlbum(name: "LambTest")
        
        session?.enableCapture = true
        session?.startCameraSession()
        state = false
        sequence = ActionQueue()
        sequence!.beginActions()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func captureimage(sender: AnyObject) {
        var img:UIImage? = session?.captureImage()
        if (img != nil) {
            album?.savePhoto(img!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        device?.scanForPeripherals()
        if (segue.identifier == "listBLEDevices") {
            var table = segue.destinationViewController as DeviceTableViewController
            table.device = device
        }
    }
    
    @IBAction func test(sender: AnyObject) {
        sequence!.addAction(AutofocuserAction(levels:10, stepsPerLevel:1000, camera:session!, device: device!))
    }

    @IBAction func moveXPlus(sender: AnyObject) {
        println(sender.currentTitle)
        println(stepText.text)
        var steps = UInt(stepText.text.toInt()!)
        
        var text = sender.currentTitle!!
        var motor: Int
        var dir: Bool
        
        if (text.rangeOfString("x") != nil) {
            motor = StageEngageStepAction.MOTOR_1
        } else if (text.rangeOfString("y") != nil) {
            motor = StageEngageStepAction.MOTOR_2
        } else {
            motor = StageEngageStepAction.MOTOR_3
        }
        
        if (text.rangeOfString("+") != nil) {
            dir = StageEngageStepAction.DIR_HIGH
        } else {
            dir = StageEngageStepAction.DIR_LOW
        }
        
        sequence!.addAction(StageEngageStepAction(dc: device!, motor: motor, dir: dir, steps:steps))
    }
    
}
