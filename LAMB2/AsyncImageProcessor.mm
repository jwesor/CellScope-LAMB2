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
}
@end

@implementation AsyncImageProcessor

@synthesize queue;

- (id) init {
    self = [super init];
    delegates = [[NSMutableArray alloc] init];
    return self;
}

- (void) addDelegate:(id <AsyncImageProcessorDelegate>)delegate {
    [delegates addObject:delegate];
}

- (void) processImage:(Mat &)image {
    if (!self.queue)
        return;
    if (operation == nil || operation.isFinished) {
        currentImage = image.clone();
        operation = [NSBlockOperation blockOperationWithBlock:
                     ^{
                         for (id <AsyncImageProcessorDelegate> delegate in delegates) {
                             [delegate onBeginImageProcess];
                         }
                         [self processImageAsync: currentImage];
                         for (id <AsyncImageProcessorDelegate> delegate in delegates) {
                             [delegate onFinishImageProcess];
                         }
                     }
                     ];
        [self.queue addOperation:operation];
    }
    
}

- (void) processImageAsync: (Mat&)currentImage {}

@end
