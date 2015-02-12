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


@protocol AsyncImageProcessorDelegate <NSObject>

- (void) onBeginImageProcess;
- (void) onFinishImageProcess;

@end

@interface AsyncImageProcessor : ImageProcessor {
#ifdef __cplusplus
//    cv::Mat currentImage;
#endif
}

@property NSOperationQueue *queue;

#ifdef __cplusplus
- (void) processImageAsync: (cv::Mat&) currentImage;
#endif
- (void) addDelegate: (id <AsyncImageProcessorDelegate>) delegate;

@end
