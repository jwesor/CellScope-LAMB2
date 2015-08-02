//
//  ImgageProcessorAction.swift
//  LAMB2
//
//  Action that will wait for an AsyncImageProcesssor to
//  run before returning. If the AsyncImageProcessor is initially
//  disabled, the action will automatically enable it when running
//  and disable it again upon completion.
//  The added image must have already been added to a CameraSession.
//
//  Created by Fletcher Lab Mac Mini on 2/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImageProcessorAction: AbstractAction, AsyncImageProcessorDelegate {
    
    let proc:AsyncImageProcessor
    var camera: CameraSession?
    var begun:Bool
    var disableWhenDone:Bool
    var removeWhenDone: Bool
    
    init(_ processor: AsyncImageProcessor) {
        proc = processor
        begun = false
        disableWhenDone = false
        removeWhenDone = false
        super.init()
    }
    
    init(_ processors: [ImageProcessor], standby: Int32 = 0, camera: CameraSession? = nil) {
        proc = AsyncImageMultiProcessor.initWithProcessors(processors)
        proc.defaultStandby = standby
        proc.enabled = false
        begun = false
        disableWhenDone = false
        removeWhenDone = true
        self.camera = camera
        super.init()
    }

    override func doExecution() {
        begun = false
        if (!proc.enabled) {
            disableWhenDone = true
            proc.enabled = true
        }
        if (removeWhenDone) {
            camera?.addAsyncImageProcessor(proc)
        }
        proc.addDelegate(self)
    }
    
    func onBeginImageProcess() {
        begun = true
    }
    
    func onFinishImageProcess() {
        if (begun) {
            if (removeWhenDone) {
                camera?.removeImageProcessor(proc)
            }
            if (disableWhenDone) {
                proc.enabled = false
            }
            proc.removeDelegate(self)
            finish()
        }
    }
    
}