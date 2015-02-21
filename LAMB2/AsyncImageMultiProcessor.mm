//
//  AsyncImageMultiProcessor.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/19/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageMultiProcessor.h"
using namespace cv;

@interface AsyncImageMultiProcessor() {
    NSMutableArray *processors;
}
@end

@implementation AsyncImageMultiProcessor

- (id) init {
    self = [super init];
    processors = [[NSMutableArray alloc] init];
    return self;
}

+ (AsyncImageMultiProcessor *) initWithProcessors: (NSArray *) procs {
    AsyncImageMultiProcessor *aimp = [[AsyncImageMultiProcessor alloc] init];
    
    for (ImageProcessor* proc in procs) {
        [aimp addImageProcessor:proc];
    }
    
    return aimp;
}

- (void) addImageProcessor:(ImageProcessor *)proc {
    [processors addObject:proc];
}

- (void) processImageAsync: (Mat&)currentImage {
    for (ImageProcessor *imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc processImage:currentImage];
        }
    }
}

- (void) updateDisplayOverlay: (Mat&)image {
    for (ImageProcessor *imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc updateDisplayOverlay:image];
        }
    }
}

@end