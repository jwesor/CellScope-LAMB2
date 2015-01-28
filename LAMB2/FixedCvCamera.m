//
//  CvCameraFixed.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/28/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "FixedCvCamera.h"

@implementation FixedCvCamera

- (void)updateOrientation {
    // prevent rotation
}

- (void)layoutPreviewLayer {
    if (self.parentView != nil) {
        CALayer* layer = self->customPreviewLayer;
        CGRect bounds = layer.bounds;
        CGSize size = self.parentView.frame.size;
        layer.position = CGPointMake(size.width/2.0, size.height/2.0);
        layer.bounds = bounds;
    }
}
@end
