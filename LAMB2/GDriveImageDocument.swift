//
//  GDriveImageDocument.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class GDriveImageDocument: ImageDocumentSaveDelegate, GDriveAdapterFileQueryResultDelegate {
    
    let drive: GDriveAdapter
    let doc: ImageDocument
    let title: String
    var identifier: String?
    var pending: Bool = false
    var queuedSave: Bool = false
    var queuedData: NSData?
    
    init(_ imgDoc: ImageDocument, drive: GDriveAdapter) {
        self.drive = drive
        self.title = imgDoc.fileName
        self.doc = imgDoc
        imgDoc.addSaveDelegate(self)
    }
    
    func onImageDocumentSave(data: NSData) {
        if (!pending) {
            pushToDrive(data)
        } else {
            queuedSave = true
            queuedData = data
        }
    }
    
    func pushToDrive(data: NSData) {
        pending = true
        DebugUtil.log("drive", "upload \(self.title) started.")
        if (identifier == nil) {
            drive.createNewFileWithTitle(title, data: data, mimeType: "image/png", delegate: self)
        } else {
            drive.updateFileWithIdentifier(identifier!, data: data, mimeType: "image/png", delegate: self)
        }
    }
    
    func onDriveFileQueryComplete(fileId: String, success: Bool) {
        DebugUtil.log("drive", "upload \(self.title) complete. success: \(success)")
        if (success) {
            identifier = fileId
        }
        pending = false
        if (queuedSave) {
            queuedSave = false
            pushToDrive(queuedData!)
        }
    }
}

class GDriveImageDocumentGenerator: ImageDocumentDelegator {
    
    let drive: GDriveAdapter
    var documents: [GDriveImageDocument] = []
    
    init (_ drive: GDriveAdapter) {
        self.drive = drive
    }
    
    func addDelegateTo(imgDoc: ImageDocument) {
        documents.append(GDriveImageDocument(imgDoc, drive: drive))
    }
}