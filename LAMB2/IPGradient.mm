//
//  IPGradient.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/16/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPGradient.h"
using namespace cv;

@implementation IPGradient

- (void) processImage:(Mat &)image {
    Mat img_gray;
    cvtColor(image, img_gray, CV_BGRA2GRAY);
    
    Mat dx;
    Scharr(img_gray, dx, img_gray.depth(), 1, 0);
    
    Mat dy;
    Scharr(img_gray, dy, img_gray.depth(), 0, 1);
    
    Mat deriv;
    add(abs(dx), abs(dy), deriv);
    cvtColor(deriv, image, CV_GRAY2BGRA);
}

@end
