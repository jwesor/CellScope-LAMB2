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
    
    init(levels: UInt, stepsPerLevel: UInt, camera: CameraSession, device: DeviceConnector, queue: NSOperationQueue) {
        focusIp = IPFocusDetector()
        
        asyncIpWrapper = AsyncImageMultiProcessor.initWithProcessors([focusIp])
        asyncIpWrapper.queue = queue
        asyncIpWrapper.enabled = false
        
        camera.addImageProcessor(asyncIpWrapper)
        
        ipAction = ImageProcessorAction(processor: asyncIpWrapper)
        focuses = []
        super.init()
        ipAction.addCompletionDelegate(self)
        addSubAction(ipAction)
        for i in 1...levels {
            addSubAction(StageEngageStepAction(dc: device, motor: StageEngageStepAction.MOTOR_1, dir: StageEngageStepAction.DIR_HIGH, steps: stepsPerLevel))
            addSubAction(ipAction)
        }
        let returnSteps = stepsPerLevel * levels;
        addSubAction(StageEngageStepAction(dc: device, motor: StageEngageStepAction.MOTOR_1, dir: StageEngageStepAction.DIR_LOW, steps: returnSteps))
    }
    
    func onActionCompleted(action: AbstractAction) {
        println("action complete %@", action)
        if (action == ipAction) {
            focuses.append(focusIp.focus)
        }
        println(focuses)
    }
}