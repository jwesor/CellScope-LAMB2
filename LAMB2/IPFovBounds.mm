//
//  IPFovBounds.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPFovBounds.h"
using namespace cv;
using namespace std;

@interface IPFovBounds () {
    int _x, _y, _width, _height;
    int _threshold;
    cv::Rect _bounds;
}
@end

@implementation IPFovBounds

@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;
@synthesize threshold = _threshold;

- (id) init {
    self = [super init];
    _threshold = 20;
    _bounds = cv::Rect(0, 0, 0, 0);
    return self;
}

- (void) processImage:(Mat &)image {
    Mat grayscale;
    cvtColor(image, grayscale, CV_BGR2GRAY);
    Mat binary;
    threshold(grayscale, binary, _threshold, 255, THRESH_BINARY);
    vector<Vec4i> hierarchy;
    vector<vector<cv::Point>> contours;
    findContours(binary, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
    double maxArea = 0;
    vector<cv::Point> largestContour;
    for (int i = 0; i < contours.size(); i ++) {
        double area = contourArea(contours[i]);
        if (area > maxArea) {
            maxArea = area;
            largestContour = contours[i];
        }
    }
    _bounds = boundingRect(largestContour);
    _x = _bounds.x;
    _y = _bounds.y;
    _width = _bounds.width;
    _height = _bounds.height;
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 0, 255, 255);
    rectangle(image, _bounds, color);
}

- (void) setBoundsAsRoi: (ImageProcessor*)imgproc {
    imgproc.roiX = _x;
    imgproc.roiY = _y;
    imgproc.roiWidth = _width;
    imgproc.roiHeight = _height;
}
@end
