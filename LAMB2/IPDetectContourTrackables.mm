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
    int _count;
    vector<cv::Rect> _rects;
}
@end

@implementation IPDetectContourTrackables

@synthesize detectedCount = _count;
@synthesize blocksize;
@synthesize c;

- (id) init {
    self = [super init];
    self.blocksize = 7;
    self.c = 3;
    self.minsize = 10;
    self.maxsize = 25;
    return self;
}

- (void) processImage:(Mat &)image {
    _count = 0;
    _rects.clear();
    
    Mat grayscale;
    cvtColor(image, grayscale, CV_BGR2GRAY);
    Mat binary;
    adaptiveThreshold(grayscale, binary, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY_INV, self.blocksize, self.c);
    cvtColor(binary, image, CV_GRAY2BGRA);
    vector<Vec4i> hierarchy;
    vector<vector<cv::Point>> contours;
    findContours(binary, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    _rects.resize(contours.size());
    _count = 0;
    for (int i = 0; i < contours.size(); i ++) {
        if (hierarchy[i][3] == -1) { // Picks positive contours only
            cv::Rect bounds = boundingRect(contours[i]);
            if (bounds.width >= self.minsize && bounds.height <= self.maxsize &&
                bounds.height >= self.minsize && bounds.height <= self.maxsize) {
                _rects[_count] = bounds;
                _count += 1;
            }
        }
    }
    _rects.resize(_count);
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 255, 255);
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
