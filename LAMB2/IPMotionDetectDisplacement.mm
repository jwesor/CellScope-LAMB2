//
//  IPMotionDetectDisplacement.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/25/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPMotionDetectDisplacement.h"
#import "ImageProcessor+CvExtension.hpp"
#import "IPDisplacement+UpdateTemplate.hpp"
using namespace cv;

@interface IPMotionDetectDisplacement() {
    IPDisplacement* _subDisplace;
    bool _scalingEnabled;
}
@end


@implementation IPMotionDetectDisplacement

@synthesize scale;
@synthesize motionThreshold;
@synthesize responsiveScaling;

- (id) init {
    self = [super init];
    self.scale = 0.5;
    self.motionThreshold = 30;
    self.responsiveScaling = true;
    _subDisplace = [[IPDisplacement alloc] init];
    _scalingEnabled = true;
    return self;
}

- (void) processImage:(Mat&) image {
    if (_scalingEnabled) {
        cv::Size targetSize(image.cols * scale, image.rows * scale);
        Mat scaled;
        resize(image, scaled, targetSize);
        [_subDisplace processImage:scaled];
    }
    
    if (!_scalingEnabled || abs(_subDisplace.dX) + abs(_subDisplace.dY) > self.motionThreshold * self.scale) {
        [super processImage:image];
    } else {
        [super updateTemplate:image];
    }
    if (self.responsiveScaling) {
        _scalingEnabled = abs(self.dX) + abs(self.dY) < self.motionThreshold;
    }
}

- (void) reset {
    [super reset];
    [_subDisplace reset];
}

- (void) setUpdateFrame:(bool)updateFrame {
    [super setUpdateFrame:updateFrame];
    [_subDisplace setUpdateFrame:updateFrame];
}

- (void) setGrayscale:(bool)grayscale {
    [super setGrayscale:grayscale];
    [_subDisplace setGrayscale:grayscale];
}

@end
