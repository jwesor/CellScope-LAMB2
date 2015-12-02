//
//  AsyncImageProcessor.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageProcessor.h"
using namespace cv;

@interface AsyncImageProcessor() {
    NSOperation *operation;
    NSMutableArray *_delegates;
    Mat currentImage;
    int currentFrame;
    NSDate *_lastProcessedFrameTime;
}
@end

@implementation AsyncImageProcessor

@synthesize queue;
@synthesize defaultStandby;
@synthesize standby;
@synthesize framesToProcess;
@synthesize delegates = _delegates;

- (id) init {
    self = [super init];
    _delegates = [[NSMutableArray alloc] init];
    framesToProcess = 1;
    currentFrame = 0;
    return self;
}

- (void) addDelegate:(id <AsyncImageProcessorDelegate>)delegate {
    [_delegates addObject:delegate];
}

- (void) removeDelegate:(id <AsyncImageProcessorDelegate>)delegate {
    [_delegates removeObject:delegate];
}

- (void) processImage:(Mat &)image {
    if (!self.queue)
        return;
    if (operation == nil || operation.isFinished) {
        currentImage = image.clone();
        if (standby > 0) {
            standby --;
            return;
        }
        currentFrame ++;
        operation = [NSBlockOperation blockOperationWithBlock: ^{
            if (currentFrame == 1) {
                for (id <AsyncImageProcessorDelegate> delegate in _delegates) {
                    [delegate onBeginImageProcess];
                }
            }
            _lastProcessedFrameTime = self.currentFrameTime;
            [self processImageAsync: currentImage];
            if (currentFrame >= framesToProcess) {
                for (id <AsyncImageProcessorDelegate> delegate in _delegates) {
                    [delegate onFinishImageProcess];
                }
                currentFrame = 0;
            }
            currentImage.release();
        }];
        [self.queue addOperation:operation];
    }
    
}

- (void) setEnabled:(bool)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        if (enabled)
            standby = defaultStandby;
    }
}

- (void) processImageAsync: (Mat&)currentImage {}

- (NSDate*) currentFrameTime {
    return _lastProcessedFrameTime;
}

@end
