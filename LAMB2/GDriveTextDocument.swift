//
//  GDriveTextDocument.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/15/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class GDriveTextDocument: TextDocumentSaveDelegate, GDriveAdapterFileQueryResultDelegate {
    
    let drive: GDriveAdapter
    let doc: TextDocument
    let title: String
    var contents: String = ""
    var identifier: String?
    var pending: Bool = false
    var queuedSave: Bool = false
    
    init(_ txtDoc: TextDocument, drive: GDriveAdapter) {
        self.drive = drive
        self.title = txtDoc.fileName
        self.contents = ""
        self.doc = txtDoc
        txtDoc.addSaveDelegate(self)
    }
    
    func onTextDocumentSave(buffer: String) {
        if (doc.append) {
            contents += buffer
        } else {
            contents = buffer
        }
        if (!pending) {
            pushToDrive(contents)
        } else {
            queuedSave = true
        }
    }
    
    func pushToDrive(contents: String) {
        let data = contents.dataUsingEncoding(NSUTF8StringEncoding)
        pending = true
        if (identifier == nil) {
            drive.createNewFileWithTitle(title, data: data, mimeType: "text/plain", delegate: self)
        } else {
            drive.updateFileWithIdentifier(identifier, data: data, mimeType: "text/plain", delegate: self)
        }

    }
    
    func onDriveFileQueryComplete(fileId: String!, success: Bool) {
        if (success) {
            identifier = fileId
        }
        pending = false
        if (queuedSave) {
            queuedSave = false
            pushToDrive(contents)
        }
    }
}