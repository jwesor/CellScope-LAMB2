//
//  ImageProcessor.h
//  LAMB2
//
//  Subclassable image processing module that can be added
//  to a CameraSession.
//
//  Subclasses of ImageProcessor should override processImage
//  and/or updateDisplayOverlay
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

@interface ImageProcessor: NSObject {
    bool _enabled;
}

@property bool enabled;
@property bool displayEnabled;

@end