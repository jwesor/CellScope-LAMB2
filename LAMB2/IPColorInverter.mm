//
//  IpGrayscaleInverter.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPColorInverter.h"
using namespace cv;

@implementation IPColorInverter

- (void) processImage:(Mat &)image {
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    circle(image, cv::Point(image.cols / 2, image.rows / 2), 100, color, 5);
}

@end
