//
//  ScanFocusAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ScanFocusAction: SequenceAction {
    
    let focusIp: IPFocusDetector
    let fovIp: IPFovBounds
    let asyncIpWrapper: AsyncImageMultiProcessor
    let ipAction: ImageProcessorAction
    let fovAction: ImageProcessorAction
    let camera: CameraSession
    var focuses: [Int32]
    var currentFocusLevel: Int
    var bestFocusLevel: Int
    var bestFocusScore: Int32
    static let SCAN_DIR = StageConstants.DIR_HIGH
    
    init(levels: Int, stepsPerLevel: UInt8, dir: Bool = ScanFocusAction.SCAN_DIR, camera: CameraSession, device: DeviceConnector, stage: StageState) {
        self.camera = camera
        
        focusIp = IPFocusDetector()
        asyncIpWrapper = AsyncImageMultiProcessor.initWithProcessors([focusIp])
        asyncIpWrapper.defaultStandby = 1
        asyncIpWrapper.enabled = false
        ipAction = ImageProcessorAction(asyncIpWrapper)
        
        fovIp = IPFovBounds()
        fovAction = ImageProcessorAction([fovIp], camera: camera)
        
        focuses = []
        currentFocusLevel = 0;
        bestFocusLevel = 0;
        bestFocusScore = 0;
        
        super.init()
        
        addSubAction(fovAction)
        
        let motor = StageConstants.MOTOR_3
        addSubAction(StageDirectionAction(device, motor: motor, dir: dir, stage: stage))
        addSubAction(StageEnableAction(device, motor: motor, stage: stage))
        addSubAction(ipAction)
        for _ in 1...levels {
            addSubAction(StageStepAction(device, motor: motor, steps: stepsPerLevel))
            addSubAction(ipAction)
        }
        addSubAction(StageDisableAction(device, motor: motor, stage: stage))
    }
    
    override func doExecution() {
        camera.addAsyncImageProcessor(asyncIpWrapper)
        focuses = []
        currentFocusLevel = 0;
        bestFocusLevel = 0;
        bestFocusScore = 0;
        super.doExecution()
    }
    
    override func onActionCompleted(action: AbstractAction) {
        if (action === ipAction) {
            let newFocus = focusIp.focus
            focuses.append(newFocus)
            if (newFocus > bestFocusScore) {
                bestFocusScore = newFocus
                bestFocusLevel = currentFocusLevel
            }
            currentFocusLevel += 1
        } else if (action === fovAction) {
            fovIp.setBoundsAsRoi(focusIp)
            focusIp.roi = true
        }
    }
    
    override func cleanup() {
        camera.removeImageProcessor(asyncIpWrapper)
        super.cleanup()
    }
}