//
//  ImageMultiProcessor.h
//  LAMB2
//
//  An ImageProcessor that runs images through a sequence of other ImageProcessors.
//  If the isolated property is set to true, the ImageMultiProcessor will not affect the
//  image received by other ImageProcessors.
//
//  Created by Fletcher Lab Mac Mini on 8/31/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageMultiProcessor : ImageProcessor

@property bool isolated;

+ (ImageMultiProcessor *)initWithProcessors: (NSArray *) procs;

- (void) addImageProcessor: (ImageProcessor *) proc;

@end
