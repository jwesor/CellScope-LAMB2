//
//  IPImageCapture.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/26/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPImageCapture.h"
#import "ImageUtils.hpp"

using namespace cv;

@interface IPImageCapture()
@property id<ImageFileWriter> writer;
@end

@implementation IPImageCapture

@synthesize writer;

+ (IPImageCapture *) initWithWriter:(id<ImageFileWriter>)writer {
    IPImageCapture *ic = [[IPImageCapture alloc] init];
    ic.writer = writer;
    return ic;
}

- (void) processImage: (Mat&)image {
    if (writer != nil) {
        Mat mat = image.clone();
        UIImage *uiimage = [ImageUtils imageWithCVMat:mat];
        [writer writeImage:uiimage];
    } else {
        NSLog(@"IPImageCapture: No ImageFileWriter was set.");
    }
}

@end
