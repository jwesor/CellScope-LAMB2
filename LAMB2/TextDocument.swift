//
//  TextDocument.swft
//  LAMB2
//
//  Saves Strings to text files inside Documents.
//
//  Created by Fletcher Lab Mac Mini on 4/3/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class TextDocument {
    
    let filePath: String
    let fileName: String
    var append: Bool
    var buffer: String
    var delegates: [TextDocumentSaveDelegate];
    
    init(_ file: String, directory: DocumentDirectory, append: Bool = true, prependTimestampToFileName: Bool = false) {
        
        var fileName = file
        if (prependTimestampToFileName) {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyyMMddHHmm"
            fileName = dateFormat.stringFromDate(NSDate()) + "_" + file
        }
        
        self.filePath = directory.getPathForFilename(file)
        self.fileName = directory.getFolderForFilename(file)
        
        self.append = append
        buffer = ""
        self.delegates = [];
    }
    
    func addSaveDelegate(delegate:TextDocumentSaveDelegate) {
        self.delegates.append(delegate);
    }
    
    func write(txt: String) {
        buffer += txt
    }
    
    func writeLine(txt: String) {
        buffer += txt + "\n"
    }
    
    func save() -> Bool {
        let output = NSOutputStream(toFileAtPath: filePath, append: append)
        if (output != nil) {
            output?.open()
            output?.write(buffer, maxLength: countElements(buffer))
            output?.close()
            for delegate in delegates {
                delegate.onTextDocumentSave(buffer);
            }
            buffer = ""
            return true
        } else {
            return false
        }
    }
}

protocol TextDocumentSaveDelegate {
    func onTextDocumentSave(buffer:String)
}