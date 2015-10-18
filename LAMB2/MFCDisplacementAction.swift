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
    let displacement: IPDisplacement
    let updateMfc: Bool

    convenience init(mfc: MFCSystem, updateMfc: Bool = true) {
        self.init(mfc: mfc, displace: mfc.displacement, preprocessors: mfc.preprocessors, updateMfc: updateMfc)
    }

    init(mfc: MFCSystem, displace: IPDisplacement, preprocessors: [ImageProcessor], updateMfc: Bool) {
    	self.mfc = mfc
    	self.updateMfc = updateMfc
        self.displacement = displacement
    	super.init(camera: mfc.camera, displace: displacement, preprocessors: preprocessors)
    }

    override func doExecution() {
        displacement.updateFrame = updateMfc
        setRoiToStage(mfc.stage)
        super.doExecution()
    }

    override func cleanup() {
    	if updateMfc {
    		mfc.applyDisplacement(dX: self.dX, dY: self.dY)
    	}
    }

}