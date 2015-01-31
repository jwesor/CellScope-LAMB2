//
//  ImageProcessor.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProcessor.h"

@implementation ImageProcessor

@synthesize enabled;

- (id) init {
    self = [super init];
    enabled = true;
    return self;
}

- (void) processImage: (cv::Mat&)image {
}

- (void) updateDisplayOverlay: (cv::Mat&)image {
}

@end