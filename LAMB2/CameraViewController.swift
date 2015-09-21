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
    
    var camera: CameraSession?
    let device: DeviceConnector = DeviceConnector()
    let queue: ActionManager = ActionQueue()
    let drive: GDriveAdapter = GDriveAdapter()
    let stage: StageState = StageState()
    var autofocus: AutofocuserAction?
    var bounder: ImgFovBoundsAction?
    var displacer: ImgDisplacementAction?
    var calib: StepCalibratorAction?
    var mfc: MFCSystem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DebugUtil.debugView = debugText
        DebugUtil.log("initializing...")
        
        camera = CameraSession.initWithPreview(preview)
        camera?.continuousAutoFocus = false
        camera?.continuousAutoWhiteBalance = false
        camera?.continuousAutoExposure = false
        camera?.startCameraSession()
        
        device.addStatusDelegate(deviceButton)
        deviceButton.updateDeviceStatusDisconnected()
        
        queue.beginActions()
        drive.addStatusDelegate(gdriveButton)
        drive.addStatusDelegate(self)
        
//        let dateFormat = NSDateFormatter()
//        dateFormat.dateFormat = "yyyyMMddHHmm"
//        let datestring = dateFormat.stringFromDate(NSDate())
//        let directory = DocumentDirectory("lamb2_\(datestring)")
        
//        let actionLog = TextDocument("action.log", directory: directory)
//        let driveLog = TextDocument("drive.log", directory: directory)
//        let cycleLog = TextDocument("cycle.log", directory: directory)
//        let gActionLog = GDriveTextDocument(actionLog, drive: drive)
//        let gCycleLog = GDriveTextDocument(cycleLog, drive: drive)
        
//        DebugUtil.setLog("action", doc: actionLog)
//        DebugUtil.setLog("drive", doc: driveLog)
//        DebugUtil.setLog("cycle", doc: cycleLog)
        
        
        autofocus = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera: camera!, device: device, stage: stage)
        bounder = ImgFovBoundsAction(camera: camera!, stage: stage)
        displacer = ImgDisplacementAction(camera: camera!)
        bounder?.bindImageProcessorRoi(displacer!)
        calib = StepCalibratorAction(device: device, stage: stage, displacer: displacer!)
        mfc = MFCSystem(camera: camera!, device: device, stage: stage)
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
    
    @IBAction func test(sender: AnyObject) {
        queue.addAction(bounder!)
        queue.addAction(autofocus!)
    }
    
    @IBAction func test2(send: AnyObject) {
        queue.addAction(calib!)
    }
    
    @IBAction func test3(sender: AnyObject) {
        queue.addAction(mfc!.subtractor)
    }
    
    @IBAction func mfcDir(sender: AnyObject) {
        let text = sender.currentTitle!!
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
        
        queue.addAction(MFCDirectionAction(mfc!, motor: motor, dir: dir, toggleEnable: true))
    }
    
    @IBAction func microstep(sender: AnyObject) {
        let text = sender.currentTitle!!
        let toggle = text.rangeOfString("True") != nil
        
        queue.addAction(StageMicrostepAction(device, enabled: toggle, stage: stage))
    }

    @IBAction func balance(sender: AnyObject) {
        queue.addAction(CameraAutoWhiteBalanceAction(camera: camera!))
        let exp = CameraAutoExposureAction(camera: camera!)
        exp.timeout = 3
        queue.addAction(exp)
        queue.addAction(CameraAutoFocusAction(camera: camera!))
    }
    
    @IBAction func moveXPlus(sender: AnyObject) {
        let steps = Int(stepText.text!)!
        
        let text = sender.currentTitle!!
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
    
    @IBAction func connectGDrive(sender: AnyObject) {
        if (!drive.isAuthorized) {
            print("sign in ")
            let authView = drive.getAuthSignInViewController()
            presentViewController(authView, animated: true, completion: nil)
        } else {
            print("sign out")
            drive.authSignOut()
        }
    }
    
    func onDriveSignIn(success: Bool) {
        print("dismiss")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onDriveSignOut() {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listBLEDevices") {
            device.scanForPeripherals()
            let table = segue.destinationViewController as! DeviceTableViewController
            table.device = device
        }
    }
}
