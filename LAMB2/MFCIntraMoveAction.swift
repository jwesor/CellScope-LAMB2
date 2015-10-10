//
//  MFCIntraMoveAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

class MFCIntraMoveAction : SequenceAction {

    let mfc: MFCSystem

    init(mfc: MFCSystem, motorSteps:[Int: (Bool, Float)], stride: UInt8 = 1) {
        self.mfc = mfc
        super.init()
        
        for (motor, (dir, steps)) in motorSteps {
            let dirAction = StageDirectionAction(mfc.device, motor: motor, dir: dir, stage: mfc.stage)
            let moveAction = MFCMoveMotorStepAction(mfc: mfc, motor: motor, dir: dir, steps: steps)
            addSubActions([dirAction, moveAction])
        }
    }
    
    override func doExecution() {
        print("GO MOVE")
        super.doExecution()
    }

}