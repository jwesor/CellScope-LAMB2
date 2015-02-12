//
//  ImgProcAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImageProcessorAction: AbstractAction, AsyncImageProcessorDelegate {
    
    let proc:AsyncImageProcessor
    var begun:Bool
    var disableWhenDone:Bool
    
    init(processor: AsyncImageProcessor) {
        proc = processor
        begun = false
        disableWhenDone = false
        super.init()
    }
    
    override func doExecution() {
        begun = false
        if (!proc.enabled) {
            disableWhenDone = true
            proc.enabled = true
        }
        proc.addDelegate(self)
    }
    
    func onBeginImageProcess() {
        begun = true
    }
    
    func onFinishImageProcess() {
        if (begun) {
            proc.enabled = !disableWhenDone
            proc.removeDelegate(self)
            finish()
        }
    }
    
}