//
//  GDriveTextDocument.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/15/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class GDriveTextDocument: TextDocumentFlushDelegate, GDriveAdapterFileQueryResultDelegate {
    
    let drive: GDriveAdapter
    let doc: TextDocument
    let title: String
    var contents: String = ""
    var identifier: String?
    var pending: Bool = false
    var queuedFlush: Bool = false
    
    init(_ textDocument: TextDocument, drive: GDriveAdapter) {
        self.drive = drive
        self.title = textDocument.fileName
        self.contents = ""
        self.doc = textDocument
        textDocument.addFlushDelegate(self)
    }
    
    func onTextDocumentFlush(buffer: String) {
        if (doc.append) {
            contents += buffer
        } else {
            contents = buffer
        }
        if (!pending) {
            pushToDrive(contents)
        } else {
            queuedFlush = true
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
        if (queuedFlush) {
            queuedFlush = false
            pushToDrive(contents)
        }
    }
}