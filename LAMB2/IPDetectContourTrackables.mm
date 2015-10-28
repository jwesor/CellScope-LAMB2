//
//  IPDetectContourTrackables.mm
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPDetectContourTrackables.h"
using namespace cv;
using namespace std;

@interface IPDetectContourTrackables() {
    int _threshold;
    int _count;
    vector<cv::Rect> _rects;
}
@end

@implementation IPDetectContourTrackables

@synthesize threshold = _threshold;
@synthesize detectedCount = _count;

- (id) init {
    self = [super init];
    _threshold = 50;
    return self;
}

- (void) processImage:(Mat &)image {
    _count = 0;
    _rects.clear();
    
    Mat grayscale;
    cvtColor(image, grayscale, CV_BGR2GRAY);
    Mat binary;
    threshold(grayscale, binary, _threshold, 255, THRESH_BINARY);
    vector<Vec4i> hierarchy;
    vector<vector<cv::Point>> contours;
    findContours(binary, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
    
    _rects.resize(contours.size());
    for (int i = 0; i < contours.size(); i ++) {
        _rects[i] = boundingRect(contours[i]);
    }
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 0, 255, 255);
    for (int i = 0; i < _count; i++) {
        rectangle(image, _rects[i], color);
    }
}

- (ContourTrackable) getDetectedTrackable:(int)index {
    ContourTrackable item;
    cv::Rect rect = _rects[index];
    item.x = rect.x;
    item.y = rect.y;
    item.width = rect.width;
    item.height = rect.height;
    return item;
}

@end
