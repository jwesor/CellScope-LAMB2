//
//  IPBackgroundSubtract.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPBackgroundSubtract.h"
using namespace cv;

@interface IPBackgroundSubtract() {
    bool _capture;
    bool _cropped;
    Mat _background;
}
@end

@implementation IPBackgroundSubtract

- (id) init {
    self = [super init];
    _capture = true;
    _cropped = false;
    return self;
}

- (void) processImage: (Mat&) image {
    if (_capture) {
        NSLog(@"Captured background!");
        _capture = false;
        cvtColor(image, _background, CV_BGRA2BGR);
    }
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    absdiff(image_copy, _background, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
}
//
//- (void) updateDisplayOverlay: (Mat&) image {
//    Mat image_copy;
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//    absdiff(image_copy, _background, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);
//}


- (void) reset {
    _cropped = false;
    _capture = true;
}

- (void) cropBackgroundToRoi {
    cv::Rect region = cv::Rect(self.roiX, self.roiY, self.roiWidth, self.roiHeight);
    if (region.x + region.width <= _background.cols && region.y + region.height <= _background.rows) {
        Mat cropped = Mat(_background, region);
        _background = cropped;
        _cropped = true;
    }
}
@end
