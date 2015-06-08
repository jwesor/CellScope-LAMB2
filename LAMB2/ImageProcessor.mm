//
//  ImageProcessor.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@implementation ImageProcessor

@synthesize enabled = _enabled;
@synthesize displayEnabled;

- (id) init {
    self = [super init];
    _enabled = true;
    self.displayEnabled = true;
    return self;
}

- (void) processImage: (cv::Mat&)image {
}

- (void) updateDisplayOverlay: (cv::Mat&)image {
}

@end