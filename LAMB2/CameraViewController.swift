//
//  CameraViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/10/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class CameraViewController: UIViewController, ActionCompletionDelegate {
    
    @IBOutlet weak var gdriveButton: GDriveStatusButton!
    @IBOutlet weak var debugText: UITextView!
    @IBOutlet weak var stepText: UITextField!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var deviceButton: DeviceStatusButton!
    
    var camera: CameraSession?
    let device = DeviceConnector()
    let queue = ActionQueue()
    let stage = StageState()
    
    var displacer: ImgDisplacementAction?
    var bounds: ImgFovBoundsAction?
    var autofocus: AutofocuserAction?
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
        
        // Logging stuff; uncomment if you actually want to save all these logs
        // TODO: Make sure logging still works after the upgrade to Xcode 7.0
//        let dateFormat = NSDateFormatter()
//        dateFormat.dateFormat = "yyyyMMddHHmm"
//        let datestring = dateFormat.stringFromDate(NSDate())
//        let directory = DocumentDirectory("lamb2_\(datestring)")
        
//        let actionLog = TextDocument("action.log", directory: directory)
//        let driveLog = TextDocument("drive.log", directory: directory)
//        let cycleLog = TextDocument("cycle.log", directory: directory)
        
//        DebugUtil.setLog("action", doc: actionLog)
//        DebugUtil.setLog("drive", doc: driveLog)
//        DebugUtil.setLog("cycle", doc: cycleLog)
//        camera?.addImageProcessor(d)
        
              
        autofocus = AutofocuserAction(startLevel: -10, endLevel: 10, stepsPerLvl: 5, camera: camera!, device: device, stage: stage)
        displacer = ImgDisplacementAction(camera: camera!, displace: IPPyramidDisplacement(), preprocessors: [IPGaussian(), IPEdgeDetect()])
        bounds = ImgFovBoundsAction(camera: camera!, stage: stage, bindRois: [displacer!.proc])
        calib = StepCalibratorAction(device: device, stage: stage, displacer: displacer!, microstep: true)
        mfc = MFCSystem(camera: camera!, device: device, stage: stage)
        
        loadDefaultStageState()
        displacer!.addCompletionDelegate(self)
    }
    
    func loadDefaultStageState() {
        let M1 = StageConstants.MOTOR_1, M2 = StageConstants.MOTOR_2
        let HI = StageConstants.DIR_HIGH, LO = StageConstants.DIR_LOW
        let microstep = true
        stage.setBacklash(49, motor: M1, dir: HI, microstep: microstep)
        stage.setBacklash(43, motor: M1, dir: LO, microstep: microstep)
        stage.setBacklash(51, motor: M2, dir: HI, microstep: microstep)
        stage.setBacklash(49, motor: M2, dir: LO, microstep: microstep)
        stage.setStep((x: 5, y: 23), motor: M1, dir: HI, microstep: microstep)
        stage.setStep((x: -2, y: -18), motor: M1, dir: LO, microstep: microstep)
        stage.setStep((x: 18, y: 0), motor: M2, dir: HI, microstep: microstep)
        stage.setStep((x: -16, y: 3), motor: M2, dir: LO, microstep: microstep)
    }
    
    @IBAction func test(sender: AnyObject) {
        // Initialize
        queue.addAction(bounds!)
        queue.addAction(mfc!.initAction)
    }
    
    @IBAction func test2(send: AnyObject) {
        // Test
        queue.addAction(displacer!)
        queue.addAction(MFCMoveAction(mfc: mfc!, x: 300, y: 300))
        queue.addAction(MFCMoveAction(mfc: mfc!, x: -300, y: -300))
        queue.addAction(displacer!)
    }
    
    func onActionCompleted(action: AbstractAction) {
        print("DISPLACER \(displacer!.dX) \(displacer!.dY)")
    }
    
    @IBAction func test3(sender: AnyObject) {
        // Background
//        let motor = StageConstants.MOTOR_2
//        let dir = StageConstants.DIR_HIGH
//        let setdir = StageDirectionAction(device, motor: motor, dir: dir, stage: stage)
//        let deadband = DeadbandStepAction(motor: motor, device: device, displacer: displacer!)
//        let stepdis = StepDisplacementAction(motor: motor, dir: dir, steps: 25, device: device, stage: stage, displacer: displacer!)
//        queue.addAction(setdir)
//        queue.addAction(deadband)
//        queue.addAction(stepdis)
//        queue.addAction(stepdis)
        queue.addAction(StageEnableAction(device, motor: StageConstants.MOTOR_1, stage: stage))
        queue.addAction(StageEnableAction(device, motor: StageConstants.MOTOR_2, stage: stage))
        queue.addAction(StageDisableAction(device, motor: StageConstants.MOTOR_1, stage: stage))
        queue.addAction(StageDisableAction(device, motor: StageConstants.MOTOR_2, stage: stage))

    }
    
    @IBAction func mfcDir(sender: AnyObject) {
        // MFC-related stuff is not working at the moment. Don't expect the MFC buttons to do anything useful!
    }
    
    @IBAction func microstep(sender: AnyObject) {
        let text = sender.currentTitle!!
        let toggle = text.rangeOfString("True") != nil
        
        queue.addAction(StageMicrostepAction(device, enabled: toggle, stage: stage))
    }

    @IBAction func balance(sender: AnyObject) {
        // Use the iPad's built in white balance, exposure correction, and autofocus
        let bal = CameraAutoWhiteBalanceAction(camera: camera!)
        bal.timeout = 10
        queue.addAction(bal)
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
        
//        if motor == StageConstants.MOTOR_3 {
            queue.addAction(StageEnableStepAction(device, motor: motor, dir: dir, steps: steps, stage: stage))
//        } else {
//            queue.addAction(StageDirectionAction(device, motor: motor, dir: dir, stage: stage))
//            queue.addAction(StageMoveAction(device, motor: motor, steps: steps))
//        }
    }
    
    @IBAction func led2off(sender: AnyObject) {
        device.send([0x27, 0, 0])
    }
    
    @IBAction func led2on(sender: AnyObject) {
        device.send([0x28, 0, 0])
        
    }
    
    @IBAction func led1off(sender: AnyObject) {
        device.send([0x25, 0, 0])
    }
    
    @IBAction func led1on(sender: AnyObject) {
        device.send([0x26, 0, 0])
    }
    
    @IBAction func connectGDrive(sender: AnyObject) {
        // Google Drive stuff is broken right now.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listBLEDevices") {
            if device.connected {
                device.send([StageDisableAction.getDisableCode(StageConstants.MOTOR_1), 0x0, 0x0])
                device.send([StageDisableAction.getDisableCode(StageConstants.MOTOR_2), 0x0, 0x0])
            }
            device.scanForPeripherals()
            let table = segue.destinationViewController as! DeviceTableViewController
            table.device = device
        }
    }
}
