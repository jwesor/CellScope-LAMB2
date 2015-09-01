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
    Mat templateRegion;
    Mat newTemplateRegion;
    int _dX, _dY;
    bool _firstFrame;
}
@end

@implementation IPDisplacement

@synthesize dX = _dX;
@synthesize dY = _dY;
@synthesize trackRegionWidth;
@synthesize trackRegionHeight;

- (id) init {
    self = [super init];
    area = cv::Rect(0, 0, 800, 800);
    roi = cv::Rect(0, 0, 300, 300);
    tracked = cv::Rect(0, 0, 300, 300);
    templateRegion = Mat(roi.height, roi.width, CV_8UC1);
    newTemplateRegion = Mat(roi.height, roi.width, CV_8UC1);
    _firstFrame = true;
    return self;
}

- (void) processImage: (Mat&) image {
    area.x = 0;
    area.y = 0;
    area.width = image.cols;
    area.height = image.rows;
    
    roi.x = (image.cols - roi.width) / 2;
    roi.y = (image.rows - roi.height) / 2;
    
    std::vector<Mat> channels(3);
    split(image, channels);
    
    Mat(channels[0], roi).copyTo(newTemplateRegion);
    
    if (templateRegion.empty() || _firstFrame) {
        _firstFrame = false;
        newTemplateRegion.copyTo(templateRegion);
    }
    
    Mat areaImage = Mat(channels[0], area);
    Mat corrResult;
    corrResult.create(areaImage.cols - templateRegion.cols + 1, areaImage.rows - templateRegion.cols + 1, CV_32FC1);
    
    matchTemplate(areaImage, templateRegion, corrResult, TM_CCORR_NORMED);
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
    Mat tmp = templateRegion;
    templateRegion = newTemplateRegion;
    newTemplateRegion = tmp;
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    rectangle(image, roi, color);
    rectangle(image, area, color);
    rectangle(image, tracked, Scalar(255, 255, 0, 255));
}

- (void) setTrackRegionWidth:(int)width {
    roi.width = tracked.width = width;
}

- (int) getTrackRegionWidth:(int)height {
    return roi.width;
}

- (void) setTrackRegionHeight:(int)height {
    roi.height = tracked.height = height;
}

- (int) getTrackRegionHeight:(int)height {
    return roi.height;
}

- (void) reset {
    _firstFrame = true;
}

@end

