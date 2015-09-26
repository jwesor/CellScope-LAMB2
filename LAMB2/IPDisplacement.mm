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
    cv::Rect _area;
    cv::Rect _roi;
    cv::Rect _tracked;
    Mat _imgTemplate;
    int _dX, _dY;
    bool _firstFrame;
}
@end

@implementation IPDisplacement

@synthesize area;
@synthesize areaX;
@synthesize areaY;
@synthesize areaWidth;
@synthesize areaHeight;

@synthesize dX = _dX;
@synthesize dY = _dY;
@synthesize templateX;
@synthesize templateY;
@synthesize templateWidth;
@synthesize templateHeight;
@synthesize grayscale;

- (id) init {
    self = [super init];
    _area = cv::Rect(0, 0, 800, 800);
    _roi = cv::Rect(0, 0, 300, 300);
    _tracked = cv::Rect(0, 0, 300, 300);
    _firstFrame = true;
    self.grayscale = true;
    return self;
}

- (void) processImage: (Mat&) image {
    if (!self.area) {
        _area.x = 0;
        _area.y = 0;
        _area.width = image.cols;
        _area.height = image.rows;
    }
    
    _roi.x = (_area.width - _roi.width) / 2 + _area.x;
    _roi.y = (_area.height - _roi.height) / 2 + _area.y;
    
    Mat imgCrop;
    imgCrop = Mat(image, _area);
    Mat imgReference;
    if (self.grayscale) {
        cvtColor(imgCrop, imgReference, CV_BGRA2GRAY);
    } else {
        imgReference = imgCrop;
    }
    
    Mat newTemplate;
    cv::Rect tmplRect(_roi.x - _area.x, _roi.y - _area.y, _roi.width, _roi.height);
    newTemplate = Mat(imgReference, tmplRect);
    
    if (_imgTemplate.empty() || _firstFrame) {
        _firstFrame = false;
        newTemplate.copyTo(_imgTemplate);
    }
    
    Mat corrResult;
    corrResult.create(imgReference.cols - _imgTemplate.cols + 1, imgReference.rows - _imgTemplate.rows + 1, CV_32FC1);
    
    matchTemplate(imgReference, _imgTemplate, corrResult, TM_CCORR_NORMED);
    normalize(corrResult, corrResult, 0, 1, NORM_MINMAX, -1, Mat());
    double minVal;
    double maxVal;
    cv::Point minLoc;
    cv::Point maxLoc;
    cv::Point matchLoc;
    minMaxLoc(corrResult, &minVal, &maxVal, &minLoc, &maxLoc, Mat());
    _tracked.x = maxLoc.x + _area.x;
    _tracked.y = maxLoc.y + _area.y;
    
    _dX = -(maxLoc.x - _roi.x);
    _dY = -(maxLoc.y - _roi.y);
    newTemplate.copyTo(_imgTemplate);
    
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    rectangle(image, _roi, color);
    rectangle(image, _area, color);
    rectangle(image, _tracked, Scalar(255, 255, 0, 255));
}

- (void) updateTemplate:(Mat &)image {
    _area.x = 0;
    _area.y = 0;
    _area.width = image.cols;
    _area.height = image.rows;
    
    _roi.x = (image.cols - _roi.width) / 2;
    _roi.y = (image.rows - _roi.height) / 2;
    
    Mat imgReference;
    if (self.grayscale) {
        cvtColor(image, imgReference, CV_BGRA2GRAY);
    } else {
        imgReference = image;
    }
    
    Mat newTemplate;
    newTemplate = Mat(imgReference, _roi);
    newTemplate.copyTo(_imgTemplate);
    _tracked.x = _roi.x;
    _tracked.y = _roi.y;
    _dX = 0;
    _dY = 0;
}

- (void) setTemplateImage:(Mat&) image {
    image.copyTo(_imgTemplate);
    _roi.width = image.cols;
    _roi.height = image.rows;
}

- (void) setTemplateWidth:(int)width {
    _roi.width = _tracked.width = width;
}

- (int) templateWidth {
    return _roi.width;
}

- (void) setTemplateHeight:(int)height {
    _roi.height = _tracked.height = height;
}

- (int) templateHeight {
    return _roi.height;
}

- (int) templateX {
    return _tracked.x;
}

- (int) templateY {
    return _tracked.y;
}

- (void) reset {
    _firstFrame = true;
}

- (void) setAreaWidth:(int) width {
    _area.width = width;
}

- (int) areaWidth {
    return _area.width;
}

- (void) setAreaHeight:(int) height {
    _area.height = height;
}

- (int) areaHeight {
    return _area.height;
}

- (void) setAreaX:(int) x {
    _area.x = x;
}

- (int) areaX {
    return _area.x;
}

- (void) setAreaY:(int) y {
    _area.y = y;
}

- (int) areaY {
    return _area.y;
}

@end
