//
//  IPDrawTrackables.mm
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/9/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPDrawTrackables.h"
using namespace cv;
using namespace std;

@interface IPDrawTrackables() {
    vector<cv::Rect> _rects;
    int _counts;
    NSObject *_lock;
}
@end

@implementation IPDrawTrackables

- (id) init {
    self = [super init];
    self->_counts = 0;
    return self;
}

- (void) resetToCount:(int)count {
    @synchronized(_lock) {
        _rects.reserve(count);
        _counts = 0;
    }
}

- (void) addTrackable:(ContourTrackable)trackable {
    @synchronized(_lock) {
        cv::Rect newRect = cv::Rect(trackable.x, trackable.y, trackable.width, trackable.height);
        _rects[_counts] = newRect;
        _counts ++;
    }
}

- (void) processImage:(Mat &)image {
    @synchronized(_lock) {
        Scalar color = Scalar(0, 0, 255, 255);
        for (int i = 0; i < _counts; i++) {
            rectangle(image, _rects[i], color);
            int n = 20;
            if (_rects[i].x > n && _rects[i].y > n && _rects[i].x + _rects[i].width < image.cols - n && _rects[i].y + _rects[i].height < image.rows - n) {
                cv::Rect search(_rects[i].x - n, _rects[i].y - n, _rects[i].width + 2 * n, _rects[i].height + 2 * n);
                rectangle(image, search, Scalar(255, 0, 0, 255));
            }
        }
    }
}

@end
