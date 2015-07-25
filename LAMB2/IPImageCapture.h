//
//  IPImageCapture.h
//  LAMB2
//
//  Image processor that will writes every frame (Mat) that it
//  sees into the ImageWriter that it is given.
//
//  Created by Fletcher Lab Mac Mini on 2/26/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@protocol ImageFileWriter

- (void) writeImage: (UIImage *)image;

@end

@interface IPImageCapture : ImageProcessor

+ (IPImageCapture *) initWithWriter: (id<ImageFileWriter>) album;

@end
