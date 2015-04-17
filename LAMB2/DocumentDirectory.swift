//
//  DocumentDirectory.swift
//  LAMB2
//
//  Represents folders/subdirectories within the Documents directory.
//  Will automatically create missing folders when initalized.
//
//  Created by Fletcher Lab Mac Mini on 4/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class DocumentDirectory {
    
    let path: String
    let folder: String
    
    init(_ directory: String = ".") {
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
        self.path = directoryPath
        self.folder = directory
    }
    
    func getFolderForFilename(filename: String) -> String {
        if (folder == ".") {
            return filename
        } else {
            return folder + "/" + filename
        }
    }
    
    func getPathForFilename(filename: String) -> String {
        return path.stringByAppendingPathComponent(filename)
    }
    
}