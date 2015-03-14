//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class CameraViewController: UIViewController {
    
    @IBOutlet weak var debugText: UITextView!
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
        
        DebugUtil.debugView = debugText
        DebugUtil.log("initializing...")
        
        session = CameraSession.initWithPreview(preview)
        session?.continuousAutoFocus = false
        session?.continuousAutoWhiteBalance = false
        
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
        /*sequence!.addAction(CameraAutoFocusAction(camera: session!))
        sequence!.addAction(AutofocuserAction(levels:10, stepsPerLevel:10, camera:session!, device: device!))
        sequence!.addAction(CameraAutoFocusAction(camera: session!))
        sequence!.addAction(CameraManualFocusAction(camera: session!, lensPosition: 0));
        sequence!.addAction(CameraAutoFocusAction(camera: session!))
        sequence!.addAction(CameraManualFocusAction(camera: session!, lensPosition: 1));
        sequence!.addAction(CameraAutoFocusAction(camera: session!))*/
        sequence!.addAction(AutofocuserAction(levels: 10, stepsPerLevel: 100, camera: session!, device: device!))
        sequence!.addAction(CameraManualFocusAction(camera: session!, lensPosition: 0))
        sequence!.addAction(CameraAutoFocusAction(camera: session!))
        sequence!.addAction(CameraManualWhiteBalanceAction(camera: session!, red: 1, green: session!.captureDevice.maxWhiteBalanceGain, blue: 1))
        sequence!.addAction(CameraAutoWhiteBalanceAction(camera: session!))
        sequence!.addAction(CameraManualExposureAction(camera: session!, milliseconds: 250, iso: 100))
        sequence!.addAction(CameraAutoExposureAction(camera: session!))
        sequence!.addAction(CameraExposureBiasAction(camera: session!, bias: session!.captureDevice.maxExposureTargetBias))
        //sequence!.addAction(CameraAutoExposureAction(camera: session!))
        sequence!.addAction(CameraAutoFocusAction(camera: session!))

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
    
    @IBAction func led2off(sender: AnyObject) {
        device?.bleSendData([0x27, 0, 0])
    }
    
    @IBAction func led2on(sender: AnyObject) {
        device?.bleSendData([0x28, 0, 0])
    }
    
    @IBAction func led1off(sender: AnyObject) {
        device?.bleSendData([0x25, 0, 0])
    }
    
    @IBAction func led1on(sender: AnyObject) {
        device?.bleSendData([0x26, 0, 0])
    }
    
    @IBAction func doAutofocus(sender: AnyObject) {
        session?.doSingleAutoFocus()
        session?.doSingleAutoWhiteBalance()
        session?.doSingleAutoExposure()
    }
}
