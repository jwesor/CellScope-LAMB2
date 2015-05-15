//
//  IPIdleFrames.mm
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 5/14/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPIdleFrames.h"
using namespace cv;

@implementation IPIdleFrames

@synthesize current = _current;
@synthesize idleFrames;

- (void) processImage:(Mat &)image {
    if (_current == 0) {
        for (id <AsyncImageProcessorDelegate> delegate in super.delegates) {
            [delegate onBeginImageProcess];
        }
    }
    _current ++;
    if (_current >= idleFrames) {
        for (id <AsyncImageProcessorDelegate> delegate in super.delegates) {
            [delegate onFinishImageProcess];
        }
    }
}

- (void) setEnabled:(bool)enabled {
    if (enabled) {
        _current = 0;
    }
    [super setEnabled:enabled];
}

@end
