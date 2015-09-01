//
//  ImageProcessor.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageProcessor () {
    cv::Rect _region;
}
@end

@implementation ImageProcessor

@synthesize enabled = _enabled;
@synthesize displayEnabled;
@synthesize roiWidth;
@synthesize roiHeight;
@synthesize roiX;
@synthesize roiY;
@synthesize roi;

- (id) init {
    self = [super init];
    _enabled = true;
    self.displayEnabled = true;
    _region = cv::Rect(0, 0, 100, 100);
    return self;
}

- (void) process: (cv::Mat&)image {
    if (self.roi) {
        cv::Mat croppedImage = cv::Mat(image, _region);
        [self processImage:croppedImage];
    } else {
        [self processImage:image];
    }
}

- (void) display: (cv::Mat&)image {
    if (self.roi) {
        cv::Mat croppedImage = cv::Mat(image, _region);
        [self updateDisplayOverlay:croppedImage];
    } else {
        [self updateDisplayOverlay:image];
    }
}

- (void) processImage: (cv::Mat&)image {
    // Implement in subclasses
}

- (void) updateDisplayOverlay: (cv::Mat&)image {
    // Implement in subclasses
}


- (void) setRoiWidth:(int) width {
    _region.width = width;
}

- (int) getRoiWidth {
    return _region.width;
}

- (void) setRoiHeight:(int) height {
    _region.height = height;
}

- (int) getRoiHeight {
    return _region.height;
}

- (void) setRoiX:(int) x {
    _region.x = x;
}

- (int) getRoiX {
    return _region.x;
}

- (void) setRoiY:(int) y {
    _region.y = y;
}

- (int) getRoiY {
    return _region.y;
}

@end