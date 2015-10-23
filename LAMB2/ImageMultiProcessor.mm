//
//  ImageMultiProcessor.mm
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 8/31/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageMultiProcessor.h"
#import "ImageProcessor+CvInterface.hpp"
using namespace cv;

@interface ImageMultiProcessor() {
    NSMutableArray *processors;
}
@end

@implementation ImageMultiProcessor

@synthesize isolated;

- (id) init {
    self = [super init];
    processors = [[NSMutableArray alloc] init];
    return self;
}

+ (ImageMultiProcessor *) initWithProcessors: (NSArray *) procs {
    ImageMultiProcessor *imp = [[ImageMultiProcessor alloc] init];
    for (ImageProcessor* proc in procs) {
        [imp addImageProcessor:proc];
    }
    return imp;
}

- (void) addImageProcessor:(ImageProcessor *)proc {
    [processors addObject:proc];
}

- (void) processImage: (Mat&)currentImage {
    if (self.isolated) {
        currentImage = currentImage.clone();
    }
    for (ImageProcessor* imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc process:currentImage];
        }
    }
    if (self.isolated) {
        currentImage.release();
    }
}

- (void) updateDisplayOverlay: (Mat&)image {
    for (ImageProcessor *imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc display:image];
        }
    }
}

@end
