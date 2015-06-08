//
//  ScanFocusAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ScanFocusAction: SequenceAction, ActionCompletionDelegate {
    
    let focusIp: IPFocusDetector
    let asyncIpWrapper: AsyncImageMultiProcessor
    let ipAction: ImageProcessorAction
    var focuses: [Int32]
    var currentFocusLevel: UInt
    var bestFocusLevel: UInt
    var bestFocusScore: Int32
    static let SCAN_DIR = StageConstants.DIR_HIGH
    
    init(levels: UInt, stepsPerLevel: UInt, camera: CameraSession, device: DeviceConnector, stage: StageState) {
        focusIp = IPFocusDetector()
        
        asyncIpWrapper = AsyncImageMultiProcessor.initWithProcessors([focusIp])
        asyncIpWrapper.defaultStandby = 1
        asyncIpWrapper.enabled = false
        
        camera.addAsyncImageProcessor(asyncIpWrapper)
        
        ipAction = ImageProcessorAction(asyncIpWrapper)
        focuses = []
        currentFocusLevel = 0;
        bestFocusLevel = 0;
        bestFocusScore = 0;
        super.init()
        ipAction.addCompletionDelegate(self)
        addSubAction(ipAction)
        for i in 1...levels {
            addSubAction(StageEnableStepAction(device, motor: StageConstants.MOTOR_3, dir: ScanFocusAction.SCAN_DIR, steps: stepsPerLevel, stage: stage))
            addSubAction(ipAction)
        }
    }
    
    func onActionCompleted(action: AbstractAction) {
        if (action == ipAction) {
            let newFocus = focusIp.focus
            focuses.append(newFocus)
            if (newFocus > bestFocusScore) {
                bestFocusScore = newFocus
                bestFocusLevel = currentFocusLevel
            }
            currentFocusLevel += 1
        }
        println(focuses)
        println(bestFocusLevel)
        println(bestFocusScore)
    }
}