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
    var currentFocusLevel: UInt;
    var bestFocusLevel: UInt;
    var bestFocusScore: Int32;
    
    init(levels: UInt, stepsPerLevel: UInt, camera: CameraSession, device: DeviceConnector) {
        focusIp = IPFocusDetector()
        
        asyncIpWrapper = AsyncImageMultiProcessor.initWithProcessors([focusIp])
        asyncIpWrapper.enabled = false
        
        camera.addAsyncImageProcessor(asyncIpWrapper)
        
        ipAction = ImageProcessorAction(processor: asyncIpWrapper)
        focuses = []
        currentFocusLevel = 0;
        bestFocusLevel = 0;
        bestFocusScore = 0;
        super.init()
        ipAction.addCompletionDelegate(self)
        addSubAction(ipAction)
        for i in 1...levels {
            addSubAction(StageEngageStepAction(dc: device, motor: StageEngageStepAction.MOTOR_3, dir: StageEngageStepAction.DIR_HIGH, steps: stepsPerLevel))
            addSubAction(ipAction)
        }
    }
    
    func onActionCompleted(action: AbstractAction) {
        println("action complete %@", action)
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