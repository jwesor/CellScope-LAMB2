//
//  IPGaussian.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/9/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPGaussian.h"
using namespace cv;

@interface IPGaussian() {
    float _sigma;
}
@end

@implementation IPGaussian

@synthesize sigma = _sigma;

- (id) init {
    self = [super init];
    self.sigma = 3;
    return self;
}


- (void) processImage:(Mat &)image {
    GaussianBlur(image, image, cv::Size(0, 0), _sigma);
}

@end
