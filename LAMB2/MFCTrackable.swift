//
//  MFCTrackable.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCTrackable : NSObject {
    
    unowned let mfc: MFCSystem
    let mapper: MFCTrackableMapper
    let displacement: IPDisplacement = IPPyramidDisplacement()
    var width: Int, height: Int
    var x: Int, y: Int
    
    init(mapper: MFCTrackableMapper, x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0) {
        self.mfc = mapper.mfc
        self.mapper = mapper
        displacement.updateTemplate = true
        displacement.centerTemplate = false
        displacement.trackTemplate = true
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    func initAtImageLocation(imLoc: (imX: Int, imY: Int), width: Int, height: Int) {
        let (imX, imY) = imLoc
        let (x, y) = mfc.imgPointToMfcLocation(imX: imX, imY: imY)
        displacement.templateX = Int32(x)
        displacement.templateY = Int32(y)
        displacement.templateWidth = Int32(width)
        displacement.templateHeight = Int32(height)
        self.width = width
        self.height = height
    }
}