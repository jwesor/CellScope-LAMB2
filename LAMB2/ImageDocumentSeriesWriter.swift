//
//  ImageDocumentSeriesWriter.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/16/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class ImageDocumentSeriesWriter: ImageFileWriter {
    
    var counter: Int
    let filename: String
    let directory: DocumentDirectory
    let separator: String
    let delegator: ImageDocumentDelegator?
    
    init(name: String, directory: DocumentDirectory, separator: String = "_", delegator: ImageDocumentDelegator? = nil) {
        self.counter = 0
        self.filename = name
        self.directory = directory
        self.separator = separator
        self.delegator = delegator
    }
    
    func writeImage(image: UIImage!) {
        let doc = ImageDocument("\(filename)\(separator)\(counter).png", directory: directory)
        counter += 1
        delegator?.addDelegateTo(doc)
        doc.writeImage(image)
    }
    
}

protocol ImageDocumentDelegator {
    func addDelegateTo(imgDoc: ImageDocument)
}