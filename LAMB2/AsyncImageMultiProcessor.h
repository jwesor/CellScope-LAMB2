//
//  AsyncImageMultiProcessor.h
//  LAMB2
//
//  An AsyncImageProcessor that wraps multiple
//  ImageProcessors and executes them asynchronously
//  in sequence. Useful for running a sequence
//  of synchronous ImageProcessors as a single action.
//  This is also more efficient than running each as individual
//  AsyncImageProcessors, since every AsyncImageProcessor creates
//  its own clone of every frame. Using an AsyncImageMultiProcessor
//  will share the clone between all processors.
//
//  Don't add other AsyncImageProcessors to this one, because
//  it won't accomplish anything.
//
//  Definitely do not add it to itself, unless you like infinite
//  recursion.
//
//  Created by Fletcher Lab Mac Mini on 2/19/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageProcessor.h"
#import "ImageProcessor.h"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@interface AsyncImageMultiProcessor : AsyncImageProcessor

+ (AsyncImageMultiProcessor *) initWithProcessors: (NSArray *) procs;

- (void) addImageProcessor: (ImageProcessor *) proc;

@end
