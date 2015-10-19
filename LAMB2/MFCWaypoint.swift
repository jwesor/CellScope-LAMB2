//
//  MFCWaypoint
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCWaypoint {

    let mfc: MFCSystem
    let displacement: IPDisplacement
    let preprocessors: [ImageProcessor]
    let displacer: ImgDisplacementAction
    let id: String

    private(set) var x: Int = 0
    private(set) var y: Int = 0

    init(mfc: MFCSystem, id:String = "") {
        self.mfc = mfc
        self.id = id
        (displacement, preprocessors) = MFCSystem.createDisplacerComponents()
    }

    func setLocation(x x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func applyDisplacement(dX dX: Int, dy: Int) {
        self.dX = x
        self.dY = y
    }
}