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
    var startX: Float = 0
    var startY: Float = 0
    let threshold: Float = 30
    let stepsPerPixel: Float = 0.02
    let pan = UIPanGestureRecognizer()
    
    var session: CameraSession?
    var device: DeviceConnector = DeviceConnector()
    var sequence: ActionManager = ActionQueue()
    let drive: GDriveAdapter = GDriveAdapter()
    let asyncIp = AsyncImageMultiProcessor()
    let stage: StageState = StageState()
    var calib: StepCalibratorAction?
    var autofocus: AutofocuserAction?
    let edge: IPEdgeDetect = IPEdgeDetect()
    let subtract: IPBackgroundSubtract = IPBackgroundSubtract()
    let displacement: IPDisplacement = IPDisplacement()
    var mfc: MFCSystem?
    
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
        
        sequence.beginActions()
        drive.addStatusDelegate(gdriveButton)
        drive.addStatusDelegate(self)
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyyMMddHHmm"
        let datestring = dateFormat.stringFromDate(NSDate())
        let directory = DocumentDirectory("lamb2_\(datestring)")
        
        let actionLog = TextDocument("action.log", directory: directory)
        let driveLog = TextDocument("drive.log", directory: directory)
        let cycleLog = TextDocument("cycle.log", directory: directory)
        let gActionLog = GDriveTextDocument(actionLog, drive: drive)
        let gCycleLog = GDriveTextDocument(cycleLog, drive: drive)
        
//        DebugUtil.setLog("action", doc: actionLog)
//        DebugUtil.setLog("drive", doc: driveLog)
//        DebugUtil.setLog("cycle", doc: cycleLog)

//        preview.userInteractionEnabled = true
//        pan.addTarget(self, action: Selector("handlePan:"))
//        preview.addGestureRecognizer(pan)
        
        edge.enabled = false
        session?.addImageProcessor(edge)
        session?.addImageProcessor(displacement)
        displacement.enabled = true
        subtract.enabled = false
        session?.addImageProcessor(subtract)
        
        calib = StepCalibratorAction(device: device, camera: session!, stage: stage)
        autofocus = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera: session!, device: device, stage: stage)
        mfc = MFCSystem(camera: session!, device: device, stage: stage)
        loadInitialStageState()
    }
    
    func loadInitialStageState() {
        let M1 = StageConstants.MOTOR_1
        let M2 = StageConstants.MOTOR_2
        let HI = StageConstants.DIR_HIGH
        let LO = StageConstants.DIR_LOW
//        Backlash M1 HI 28
//        Backlash M1 LO 27
//        Backlash M2 HI 45
//        Backlash M2 LO 41
//        Step M1 HI (6, 8)
//        Step M1 LO (-6, -2)
//        Step M2 HI (-5, -2)
//        Step M2 LO (6, 2)
        stage.setBacklash(28, motor: M1, dir: HI)
        stage.setBacklash(27, motor: M1, dir: LO)
        stage.setBacklash(45, motor: M2, dir: HI)
        stage.setBacklash(41, motor: M2, dir: LO)
        stage.setStep((x: 6, y: 8), motor: M1, dir: HI)
        stage.setStep((x: -6, y: -2), motor: M1, dir: LO)
        stage.setStep((x: -5, y: -2), motor: M2, dir: HI)
        stage.setStep((x: 6, y: 2), motor: M2, dir: LO)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listBLEDevices") {
            device.scanForPeripherals()
            var table = segue.destinationViewController as! DeviceTableViewController
            table.device = device
        }
    }
    
    @IBAction func test(sender: AnyObject) {
        displacement.reset()
//        sequence.addAction(mfc!.initNoCalibAction)
    }
    
    @IBAction func test2(send: AnyObject) {
//        edge.enabled = !edge.enabled
//        subtract.enabled = !subtract.enabled
//        sequence.addAction(mfc!.autofocuser)
//        
        // TODO: Investigate reason for significant backlash observed on the return MFCMoveAction
//        mfc!.bounds.setBoundsAsRoi(displacement)
//        displacement.roi = true
        sequence.addAction(ImageProcessorAction([displacement], camera: session!))
        sequence.addAction(MFCMoveAction(mfc!, x: -500, y: -500))
        sequence.addAction(MFCMoveAction(mfc!, x: 500, y: 500))
        sequence.addAction(ImageProcessorAction([displacement], camera: session!))
        println("\(displacement.dX) \(displacement.dY)")
    }
    
    @IBAction func test3(sender: AnyObject) {
        sequence.addAction(mfc!.subtractor)
    }
    
    @IBAction func mfcDir(sender: AnyObject) {
        var steps = stepText.text.toInt()!
        
        var text = sender.currentTitle!!
        var motor: Int
        var dir: Bool
        
        if (text.rangeOfString("M1") != nil) {
            motor = StageConstants.MOTOR_1
        } else {
            motor = StageConstants.MOTOR_2
        }
        
        if (text.rangeOfString("HI") != nil) {
            dir = StageConstants.DIR_HIGH
        } else {
            dir = StageConstants.DIR_LOW
        }
        
        sequence.addAction(MFCDirectionAction(mfc!, motor: motor, dir: dir, toggleEnable: true))
    }
    
    @IBAction func microstep(sender: AnyObject) {
        let text = sender.currentTitle!!
        let toggle = text.rangeOfString("True") != nil
        
        sequence.addAction(StageMicrostepAction(device, enabled: toggle, stage: stage))
    }

    @IBAction func balance(sender: AnyObject) {
        sequence.addAction(CameraAutoWhiteBalanceAction(camera: session!))
        let exp = CameraAutoExposureAction(camera: session!)
        exp.timeout = 3
        sequence.addAction(exp)
        sequence.addAction(CameraAutoFocusAction(camera: session!))
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
        sequence.addAction(StageEnableStepAction(device, motor: motor, dir: dir, steps:steps, stage: stage))
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
                let stepX = Int(diffX * stepsPerPixel)
                let dirX = startX > x ? StageConstants.DIR_HIGH : StageConstants.DIR_LOW
                sequence.addAction(StageEnableStepAction(device, motor: StageConstants.MOTOR_2, dir: dirX, steps: stepX, stage: stage))
            }
            
            let diffY = abs(startY - y)
            if (diffY > threshold) {
                let stepY = Int(diffY * stepsPerPixel)
                let dirY = startY < y ? StageConstants.DIR_HIGH : StageConstants.DIR_LOW
                sequence.addAction(StageEnableStepAction(device, motor: StageConstants.MOTOR_1, dir: dirY, steps: stepY, stage: stage))
            }
        }
    }
}
