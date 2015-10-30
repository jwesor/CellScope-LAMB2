//
//  MFCDisplacmentAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class MFCDisplacementAction : ImgDisplacementAction {

    let mfc: MFCSystem
    let updateMfc: Bool
    var firstRun: Bool = true

    convenience init(mfc: MFCSystem, updateMfc: Bool = true) {
        self.init(mfc: mfc, displace: mfc.displacement, preprocessors: mfc.preprocessors, updateMfc: updateMfc)
    }

    init(mfc: MFCSystem, displace: IPDisplacement, preprocessors: [ImageProcessor], updateMfc: Bool) {
    	self.mfc = mfc
    	self.updateMfc = updateMfc
    	super.init(camera: mfc.camera, displace: displace, preprocessors: preprocessors)
        self.stage = mfc.stage
    }

    override func doExecution() {
        displacement.updateFrame = updateMfc
        super.doExecution()
    }

    override func cleanup() {
        super.cleanup()
    	if updateMfc {
    		mfc.applyDisplacement(dX: self.dX, dY: self.dY)
    	}
    }

}