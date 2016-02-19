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
    var camera: CvCameraSession?
    var stage: StageState?
    private var begun:Bool
    private var disableWhenDone:Bool
    private var removeWhenDone: Bool
    
    init(_ processor: AsyncImageProcessor) {
        proc = processor
        begun = false
        disableWhenDone = false
        removeWhenDone = false
        super.init()
    }
    
    init(_ processors: [ImageProcessor], standby: Int32 = 0, camera: CvCameraSession? = nil, stage: StageState? = nil) {
        proc = AsyncImageMultiProcessor.initWithProcessors(processors)
        proc.defaultStandby = standby
        proc.enabled = false
        begun = false
        disableWhenDone = false
        removeWhenDone = camera != nil
        self.camera = camera
        self.stage = stage
        super.init()
    }

    override func doExecution() {
        begun = false
        if (!proc.enabled) {
            disableWhenDone = true
            proc.enabled = true
        }
        if (stage != nil) && (stage!.isFovBounded() && !proc.roi) {
            print("\(self)")
            setRoiToStage(stage!)
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

    func setRoiToStage(stage: StageState) {
        if stage.isFovBounded() {
            stage.setImageProcessorRoiToFov(self.proc)
            self.proc.roi = true
        }
    }
    
    func setRoi(x x: Int, y: Int, width: Int, height: Int) {
        proc.roiX = Int32(x)
        proc.roiY = Int32(y)
        proc.roiWidth = Int32(width)
        proc.roiHeight = Int32(height)
        proc.roi = true
    }
}