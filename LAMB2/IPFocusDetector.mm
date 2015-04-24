//
//  IPFocusDetector.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPFocusDetector.h"
using namespace cv;

@interface IPFocusDetector() {
    int _focus;
}
@end

@implementation IPFocusDetector

@synthesize focus = _focus;
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
    cvtColor(image, gray, CV_BGR2GRAY);
    Canny(gray, gray, 64, 96);
    _focus = countNonZero(gray);
}

@end
