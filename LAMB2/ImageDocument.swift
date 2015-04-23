//
//  ImageFile.swift
//  LAMB2
//
//  Saves UIImages as pngs inside Documents.
//
//  Created by Fletcher Lab Mac Mini on 4/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImageDocument {
    
    let filePath: String
    let fileName: String
    var delegates: [ImageDocumentSaveDelegate];
    
    init(_ file: String, directory: DocumentDirectory) {
        var fileName = file
        self.filePath = directory.getPathForFilename(file)
        self.fileName = directory.getFolderForFilename(file)
        self.delegates = [];
    }
    
    func writeImage(image: UIImage) {
        let data = UIImagePNGRepresentation(image)
        data.writeToFile(filePath, atomically: true)
        for delegate in delegates {
            delegate.onImageDocumentSave(data)
        }
    }
    
    func addSaveDelegate(delegate: ImageDocumentSaveDelegate) {
        delegates.append(delegate)
    }

}

protocol ImageDocumentSaveDelegate {
    func onImageDocumentSave(data: NSData);
}