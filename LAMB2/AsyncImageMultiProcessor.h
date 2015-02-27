//
//  AsyncImageMultiProcessor.h
//  LAMB2
//
//  An AsyncImageProcessor that wraps multiple ImageProcessors
//  and executes them asynchronously in sequence.
//  Useful for running a chain of synchronous ImageProcessors as
//  a single async action, especially if they all need to use
//  the same frame.
//
//  This is also more efficient than running each as an individual
//  AsyncImageProcessors, since every AsyncImageProcessor creates
//  its own clone of every frame. Using an AsyncImageMultiProcessor
//  will create a single clone shared between all processes.
//
//  Adding other AsyncImageProcessors to this one will not accomplish
//  very much.
//
//  Definitely do not add it to itself, unless you like infinite
//  recursion.
//
//  Created by Fletcher Lab Mac Mini on 2/19/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageProcessor.h"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@interface AsyncImageMultiProcessor : AsyncImageProcessor

+ (AsyncImageMultiProcessor *) initWithProcessors: (NSArray *) procs;

- (void) addImageProcessor: (ImageProcessor *) proc;

@end
