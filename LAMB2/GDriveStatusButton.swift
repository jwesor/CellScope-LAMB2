//
//  GDriveStatusButton.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class GDriveStatusButton : UIButton, GDriveAdapterStatusDelegate {
    
    func onDriveSignIn(success: Bool) {
        if (success) {
            self.setTitle("GDrive Sign Out", forState: UIControlState.Normal)
        }
    }
    
    func onDriveSignOut() {
        self.setTitle(("GDrive Sign In"), forState: UIControlState.Normal)
    }
    
}