
//
//  GDriveAdapter.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/21/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation

class GDriveAdapter {
    
    var isAuthorized: Bool
    
    init() {
        isAuthorized = false
        
    }
    
    func authSignOut() {
        
    }
    
    func addStatusDelegate(delegate: GDriveAdapterStatusDelegate) {
        
    }
    
    func getAuthSignInViewController() -> UIViewController {
        return UIViewController()
    }
    
    func createNewFileWithTitle(title: String, data: NSData, mimeType: String, delegate: GDriveAdapterFileQueryResultDelegate) {
        
    }
    
    func updateFileWithIdentifier(title: String, data: NSData, mimeType: String, delegate: GDriveAdapterFileQueryResultDelegate) {
        
    }
}

protocol GDriveAdapterStatusDelegate {
    func onDriveSignIn(success: Bool);
    func onDriveSignOut();
}

protocol GDriveAdapterFileQueryResultDelegate {
    func onDriveFileQueryComplete(fileId: String, success: Bool);
}
