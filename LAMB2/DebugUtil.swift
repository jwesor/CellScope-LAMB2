//
//  DebugUtil.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 3/4/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

struct DebugUtil {
    
    static var debugView: UITextView?
    static var debugText: String = ""
    static var logfiles: [String:TextDocument] = [String:TextDocument]()
    
    static func log(str: String) {
        debugText = str + debugText
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.debugView?.text = self.debugText
            return
        }
    }
    
    static func setLog(log: String, doc: TextDocument) {
        logfiles[log] = doc
    }
    
    static func log(log: String, _ str: String) {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let doc = logfiles[log]
        doc?.write(dateFormat.stringFromDate(NSDate()))
        doc?.write(" // ")
        doc?.writeLine(str)
        doc?.save()
    }
    
}