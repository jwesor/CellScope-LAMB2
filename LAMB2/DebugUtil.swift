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
    
    static func log(str: String) {
        debugText = str + debugText
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.debugView?.text = self.debugText
            return
        }
    }
    
}