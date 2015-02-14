//
//  AsyncImageProcessor.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/11/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProcessor.h"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif


@protocol AsyncImageProcessorDelegate

- (void) onBeginImageProcess;
- (void) onFinishImageProcess;

@end

@interface AsyncImageProcessor : ImageProcessor {
}

@property NSOperationQueue *queue;
@property int defaultStandby;
@property int standby;
@property int framesToProcess;

#ifdef __cplusplus
- (void) processImageAsync: (cv::Mat&) currentImage;
#endif
- (void) addDelegate: (id <AsyncImageProcessorDelegate>) delegate;
- (void) removeDelegate: (id <AsyncImageProcessorDelegate>) delegate;

@end
