//
//  TextDocument.swft
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/3/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class TextDocument {
    
    let filePath: NSString
    let append: Bool
    var buffer: String
    
    init(file: String, directory: String = ".", append: Bool = false, prependTimestampToFileName: Bool = false) {
        let fileManager = NSFileManager.defaultManager()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let directoryPath = documentsPath.stringByAppendingPathComponent(directory)
        // Error handling here is primitive. Expand this eventually.
        if (!fileManager.fileExistsAtPath(directoryPath)) {
            var error: NSError?
            if (!fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil, error: &error)) {
                println("Failed to create directory \(directoryPath)")
            }
        }
        var fileName = file
        if (prependTimestampToFileName) {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyyMMddHHmm"
            fileName = dateFormat.stringFromDate(NSDate()) + "_" + file
        }
        filePath = directoryPath.stringByAppendingPathComponent(fileName)
        self.append = append
        buffer = ""
    }
    
    func write(txt: String) {
        buffer += txt
    }
    
    func writeLine(txt: String) {
        buffer += txt + "\n"
    }
    
    func flush() -> Bool {
        let output = NSOutputStream(toFileAtPath: filePath, append: append)
        if (output != nil) {
            output?.open()
            output?.write(buffer, maxLength: countElements(buffer))
            output?.close()
            buffer = ""
            return true
        } else {
            return false
        }
    }
}