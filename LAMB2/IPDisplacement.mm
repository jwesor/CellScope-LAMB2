//
//  IPDisplacement.m
//  LAMB2
//
//  Tracks how much the 
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPDisplacement.h"
using namespace cv;

@interface IPDisplacement() {
    cv::Rect cropped;
    cv::Rect roi;
    cv::Rect tracked;
    Mat templateRegion;
    Mat newTemplateRegion;
    int _dX, _dY;
    bool _firstFrame;
}
@end

@implementation IPDisplacement

@synthesize dX = _dX;
@synthesize dY = _dY;
@synthesize regionWidth;
@synthesize regionHeight;
@synthesize cropWidth;
@synthesize cropHeight;
@synthesize cropX;
@synthesize cropY;
@synthesize croppingEnabled;
@synthesize croppingCentered;

- (id) init {
    self = [super init];
    cropped = cv::Rect(0, 0, 800, 800);
    roi = cv::Rect(0, 0, 300, 300);
    tracked = cv::Rect(0, 0, 300, 300);
    templateRegion = Mat(roi.height, roi.width, CV_8UC1);
    newTemplateRegion = Mat(roi.height, roi.width, CV_8UC1);
    self.croppingEnabled = false;
    self.croppingCentered = true;
    _firstFrame = true;
    return self;
}

- (void) processImage: (Mat&) image {
    if (self.croppingEnabled && self.croppingCentered) {
        cropped.x = (image.cols - cropped.width) / 2;
        cropped.y = (image.rows - cropped.height) / 2;
    } else if (!self.croppingEnabled) {
        cropped.x = 0;
        cropped.y = 0;
        cropped.width = image.cols;
        cropped.height = image.rows;
    }
    roi.x = (image.cols - roi.width) / 2;
    roi.y = (image.rows - roi.height) / 2;
    
    std::vector<Mat> channels(3);
    split(image, channels);
    
    Mat(channels[0], roi).copyTo(newTemplateRegion);
    
    if (templateRegion.empty() || _firstFrame) {
        _firstFrame = false;
        newTemplateRegion.copyTo(templateRegion);
    }
    
    Mat croppedImage = Mat(channels[0], cropped);
    Mat corrResult;
    corrResult.create(croppedImage.cols - templateRegion.cols + 1, croppedImage.rows - templateRegion.cols + 1, CV_32FC1);
    
    matchTemplate(croppedImage, templateRegion, corrResult, TM_CCORR_NORMED);
    normalize(corrResult, corrResult, 0, 1, NORM_MINMAX, -1, Mat());
    double minVal;
    double maxVal;
    cv::Point minLoc;
    cv::Point maxLoc;
    cv::Point matchLoc;
    minMaxLoc(corrResult, &minVal, &maxVal, &minLoc, &maxLoc, Mat());
    tracked.x = maxLoc.x + cropped.x;
    tracked.y = maxLoc.y + cropped.y;
    
    _dX = -(maxLoc.x - (cropped.width - roi.width) / 2);
    _dY = -(maxLoc.y - (cropped.height - roi.height) / 2);
    Mat tmp = templateRegion;
    templateRegion = newTemplateRegion;
    newTemplateRegion = tmp;
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    rectangle(image, roi, color);
    rectangle(image, cropped, color);
    rectangle(image, tracked, Scalar(255, 255, 0, 255));
}

- (void) setCropWidth:(int) width {
    cropped.width = width;
}

- (int) getCropWidth {
    return cropped.width;
}

- (void) setCropHeight:(int) height {
    cropped.height = height;
}

- (int) getCropHeight {
    return cropped.height;
}

- (void) setCropX:(int) x {
    cropped.x = x;
}

- (int) getCropX {
    return cropped.x;
}

- (void) setCropY:(int) y {
    cropped.y = y;
}

- (int) getCropY {
    return cropped.y;
}

- (void) setRegionWidth:(int)width {
    roi.width = tracked.width = width;
}

- (int) getRegionWidth:(int)height {
    return roi.width;
}

- (void) setRegionHeight:(int)height {
    roi.height = tracked.height = height;
}

- (int) getRegionHeight:(int)height {
    return roi.height;
}

- (void) reset {
    _firstFrame = true;
}

@end

