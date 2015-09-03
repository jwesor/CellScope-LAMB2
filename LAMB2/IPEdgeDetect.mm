//
//  IPEdgeDetect.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPEdgeDetect.h"
using namespace cv;

@implementation IPEdgeDetect

@synthesize lowerThreshold = _lower;
@synthesize upperThreshold = _upper;

- (id) init {
    self = [super init];
    _lower = 64;
    _upper = 96;
    return self;
}

- (void) processImage:(Mat &)image {
    Mat gray;
    cvtColor(image, gray, CV_BGRA2GRAY);
    Canny(gray, gray, _lower, _upper);
    cvtColor(gray, image, CV_GRAY2BGRA);
}

@end
