//
//  TouchStagePan.swift
//  LAMB2
//
//  Here's something that fiddles around with a touch-controlled stage.
//
//  Created by Fletcher Lab Mac Mini on 1/21/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class TouchStagePan {
    
    let view: UIView
    let pan:UIPanGestureRecognizer = UIPanGestureRecognizer()
    let device: DeviceConnector
    
    init(view: UIView, device: DeviceConnector) {
        self.view = view
        self.device = device
        view.userInteractionEnabled = true
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: "panStage:")
        view.addGestureRecognizer(pan)
        pan.enabled = true
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "tapStage:")
        view.addGestureRecognizer(tap)
        tap.enabled = true
    }
    
    @objc func tapStage(sender: UITapGestureRecognizer) {
        let translation = sender.locationInView(view)
        NSLog("%f %f", translation.x, translation.y)
    }
    
    @objc func panStage(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        if (sender.state == UIGestureRecognizerState.Began) {
            device.bleSendData([0x04, 0x0, 0x0])
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            device.bleSendData([0x14, 0x0, 0x0])
        }
        
    }
}