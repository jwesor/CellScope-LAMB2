//
//  AsyncImageProcessor.h
//  LAMB2
//
//  An ImageProcessor that works asynchronously.
//  Heavy operations will cause the framerate of the camera
//  to fall if done on the camera thread. Using AsyncImageProcessor
//  instead of ImageProcessor will run operations concurrently,
//  not on every frame.
//
//  AsyncImageProcessors are isolated, meaning their operations
//  do not affect the images received by other image processors.
//
//  Created by Fletcher Lab Mac Mini on 2/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@protocol AsyncImageProcessorDelegate

- (void) onBeginImageProcess;
- (void) onFinishImageProcess;

@end

@interface AsyncImageProcessor : ImageProcessor {
}

/* The operation queue that will be used to run async operations. */
@property NSOperationQueue *queue;

/* Default number of frames that standby will be set to when enabled. */
@property int defaultStandby;

/* Number of frames to wait before beginning processing. Useful for operations
 * that compare old frames to new ones, by waiting to capture old frames first. */
@property int standby;

/* Number of frames that should be processed before delegates are notified
 * of completion. */
@property int framesToProcess;

@property (readonly) NSMutableArray *delegates;

- (void) addDelegate: (id <AsyncImageProcessorDelegate>) delegate;
- (void) removeDelegate: (id <AsyncImageProcessorDelegate>) delegate;

@end
