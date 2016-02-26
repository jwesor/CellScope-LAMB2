//
//  AsyncImageMultiProcessor.h
//  LAMB2
//
//  An AsyncImageProcessor that takes multiple ImageProcessors
//  and executes them asynchronously in sequence.
//  Useful for running a chain of ImageProcessors as
//  a single AsyncImageProcessor, especially if they all need to use
//  the same frame.
//
//  This is also more efficient than running each as an individual
//  AsyncImageProcessors, since every AsyncImageProcessor creates
//  its own clone of every frame. Using an AsyncImageMultiProcessor
//  will create a single clone shared between all processes.
//
//  Definitely do not add it to itself, unless you like infinite
//  recursion.
//
//  Created by Fletcher Lab Mac Mini on 2/19/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageProcessor.h"

@interface AsyncImageMultiProcessor : AsyncImageProcessor

+ (AsyncImageMultiProcessor *) initWithProcessors: (NSArray *) procs;

- (void) addImageProcessor: (ImageProcessor *) proc;

- (void) removeAllImageProcessors;

@end
