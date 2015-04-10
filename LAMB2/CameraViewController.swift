//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class CameraViewController: UIViewController, GDriveAdapterStatusDelegate {
    
    @IBOutlet weak var gdriveButton: GDriveStatusButton!
    @IBOutlet weak var debugText: UITextView!
    @IBOutlet weak var stepText: UITextField!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var deviceButton: DeviceStatusButton!
    var session: CameraSession?
    var device: DeviceConnector = DeviceConnector()
    var sequence: ActionManager = ActionQueue()
    var album: PhotoAlbum = PhotoAlbum(name: "LambTest")
    var startX: Float = 0
    var startY: Float = 0
    let threshold: Float = 30
    let stepsPerPixel: Float = 0.02
    let pan = UIPanGestureRecognizer()
    let drive: GDriveAdapter = GDriveAdapter()
    
    var async:AsyncImageMultiProcessor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DebugUtil.debugView = debugText
        DebugUtil.log("initializing...")
        
        session = CameraSession.initWithPreview(preview)
        session?.continuousAutoFocus = false
        session?.continuousAutoWhiteBalance = true
        session?.continuousAutoExposure = true
        session?.startCameraSession()
        
        device.addStatusDelegate(deviceButton)
        deviceButton.updateDeviceStatusDisconnected()
        
        sequence.beginActions()
        drive.addStatusDelegate(gdriveButton)
        drive.addStatusDelegate(self)
        
//        preview.userInteractionEnabled = true
//        pan.addTarget(self, action: Selector("handlePan:"))
//        preview.addGestureRecognizer(pan)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listBLEDevices") {
            device.scanForPeripherals()
            var table = segue.destinationViewController as DeviceTableViewController
            table.device = device
        }
    }
    
    @IBAction func test(sender: AnyObject) {
        let doc = TextDocument(file: "foo.txt", directory: "testtesttest", append: true, prependTimestampToFileName: false)
        let doc2 = TextDocument(file: "foo3.txt", append: false, prependTimestampToFileName: true)
        doc.writeLine("Hello world")
        doc.flush()
        doc.write("How's")
        doc.flush()
        doc.writeLine(" life?")
        doc.write("Good")
        doc.writeLine("bye")
        doc.flush()
        doc2.write("testing")
        doc2.flush()
        doc2.write("testing some more")
        sequence.addAction(CameraAutoFocusAction(camera: session!))
//        sequence!.addAction(AutofocuserAction(levels: 10, stepsPerLevel: 20, camera: session!, device: device!))
    }

    @IBAction func moveXPlus(sender: AnyObject) {
        var steps = UInt(stepText.text.toInt()!)
        
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
        sequence.addAction(StageEnableStepAction(device, motor: motor, dir: dir, steps:steps))
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
    
    @IBAction func connectGDrive(sender: AnyObject) {
        if (!drive.isAuthorized) {
            println("sign in ")
            let authView = drive.getAuthSignInViewController()
            presentViewController(authView, animated: true, completion: nil)
        } else {
            println("sign out")
            drive.authSignOut()
        }
    }
    
    func onDriveSignIn(success: Bool) {
        println("dismiss")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onDriveSignOut() {}
    
    @objc func handlePan(sender: UIPanGestureRecognizer!) {
        let translation = sender.locationInView(view)
        let x = Float(translation.x)
        let y = Float(translation.y)
        if (sender.state == UIGestureRecognizerState.Began) {
            startX = x
            startY = y
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            let diffX = abs(startX - x)
            if (diffX > threshold) {
                let stepX = UInt(diffX * stepsPerPixel)
                let dirX = startX > x ? StageConstants.DIR_HIGH : StageConstants.DIR_LOW
                sequence.addAction(StageEnableStepAction(device, motor: StageConstants.MOTOR_2, dir: dirX, steps: stepX))
            }
            
            let diffY = abs(startY - y)
            if (diffY > threshold) {
                let stepY = UInt(diffY * stepsPerPixel)
                let dirY = startY < y ? StageConstants.DIR_HIGH : StageConstants.DIR_LOW
                sequence.addAction(StageEnableStepAction(device, motor: StageConstants.MOTOR_1, dir: dirY, steps: stepY))
            }
        }
    }
}
