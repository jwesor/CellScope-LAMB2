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
    NSMutableArray *delegates;
    Mat currentImage;
    int currentFrame;
}
@end

@implementation AsyncImageProcessor

@synthesize queue;
@synthesize defaultStandby;
@synthesize standby;
@synthesize framesToProcess;

- (id) init {
    self = [super init];
    delegates = [[NSMutableArray alloc] init];
    framesToProcess = 1;
    currentFrame = 0;
    return self;
}

- (void) addDelegate:(id <AsyncImageProcessorDelegate>)delegate {
    [delegates addObject:delegate];
}

- (void) removeDelegate:(id <AsyncImageProcessorDelegate>)delegate {
    [delegates removeObject:delegate];
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
                for (id <AsyncImageProcessorDelegate> delegate in delegates) {
                    [delegate onBeginImageProcess];
                }
            }
            [self processImageAsync: currentImage];
            if (currentFrame >= framesToProcess) {
                for (id <AsyncImageProcessorDelegate> delegate in delegates) {
                    [delegate onFinishImageProcess];
                }
                currentFrame = 0;
            }
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

@end
