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
    cv::Rect area;
    cv::Rect roi;
    cv::Rect tracked;
    Mat imgTemplate;
    int _dX, _dY;
    bool _firstFrame;
}
@end

@implementation IPDisplacement

@synthesize dX = _dX;
@synthesize dY = _dY;
@synthesize templateWidth;
@synthesize templateHeight;
@synthesize grayscale;

- (id) init {
    self = [super init];
    area = cv::Rect(0, 0, 800, 800);
    roi = cv::Rect(0, 0, 300, 300);
    tracked = cv::Rect(0, 0, 300, 300);
    _firstFrame = true;
    self.grayscale = true;
    return self;
}

- (void) processImage: (Mat&) image {
    area.x = 0;
    area.y = 0;
    area.width = image.cols;
    area.height = image.rows;
    
    roi.x = (image.cols - roi.width) / 2;
    roi.y = (image.rows - roi.height) / 2;
    
    Mat imgReference;
    if (self.grayscale) {
        cvtColor(image, imgReference, CV_BGRA2GRAY);
    } else {
        imgReference = image;
    }
    
    Mat newTemplate;
    newTemplate = Mat(imgReference, roi);
    
    if (imgTemplate.empty() || _firstFrame) {
        _firstFrame = false;
        newTemplate.copyTo(imgTemplate);
    }
    
    Mat corrResult;
    corrResult.create(imgReference.cols - imgTemplate.cols + 1, imgReference.rows - imgTemplate.rows + 1, CV_32FC1);
    
    matchTemplate(imgReference, imgTemplate, corrResult, TM_CCORR_NORMED);
    normalize(corrResult, corrResult, 0, 1, NORM_MINMAX, -1, Mat());
    double minVal;
    double maxVal;
    cv::Point minLoc;
    cv::Point maxLoc;
    cv::Point matchLoc;
    minMaxLoc(corrResult, &minVal, &maxVal, &minLoc, &maxLoc, Mat());
    tracked.x = maxLoc.x + area.x;
    tracked.y = maxLoc.y + area.y;
    
    _dX = -(maxLoc.x - (area.width - roi.width) / 2);
    _dY = -(maxLoc.y - (area.height - roi.height) / 2);
    newTemplate.copyTo(imgTemplate);
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    rectangle(image, roi, color);
    rectangle(image, area, color);
    rectangle(image, tracked, Scalar(255, 255, 0, 255));
}

- (void) setTemplateWidth:(int)width {
    roi.width = tracked.width = width;
}

- (int) templateWidth:(int)height {
    return roi.width;
}

- (void) setTemplateHeight:(int)height {
    roi.height = tracked.height = height;
}

- (int) templateHeight:(int)height {
    return roi.height;
}

- (void) reset {
    _firstFrame = true;
}

@end
