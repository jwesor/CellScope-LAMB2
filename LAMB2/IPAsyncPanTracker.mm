//
//  IPAsyncPanTracker.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/19/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPAsyncPanTracker.h"
using namespace cv;

@interface IPAsyncPanTracker() {
    cv::Rect cropped;
    cv::Rect roi;
    cv::Rect tracked;
    Mat templateRegion;
    Mat newTemplateRegion;
}
@end

@implementation IPAsyncPanTracker

- (id) init {
    self = [super init];
    cropped = cv::Rect(0, 0, 400, 400);
    roi = cv::Rect(0, 0, 200, 200);
    tracked = cv::Rect(0, 0, 200, 200);
    templateRegion = Mat(roi.height, roi.width, CV_8UC1);
    newTemplateRegion = Mat(roi.height, roi.width, CV_8UC1);
    return self;
}

- (void) processImageAsync: (Mat&) image {
    cropped.x = (image.cols - cropped.width) / 2;
    cropped.y = (image.rows - cropped.height) / 2;
    roi.x = (image.cols - roi.width) / 2;
    roi.y = (image.rows - roi.height) / 2;
    
    vector<Mat> channels(3);
    split(image, channels);
    
    Mat(channels[0], roi).copyTo(newTemplateRegion);
    
    if (templateRegion.empty()) {
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
    
    Mat tmp = templateRegion;
    templateRegion = newTemplateRegion;
    newTemplateRegion = tmp;
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    rectangle(image, roi, color);
    rectangle(image, cropped, color);
    rectangle(image, tracked, color);
}

@end
