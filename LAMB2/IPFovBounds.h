//
//  IPFovBounds.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/2/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface IPFovBounds : ImageProcessor

@property (readonly) int x;
@property (readonly) int y;
@property (readonly) int width;
@property (readonly) int height;
@property int threshold;

- (void) setBoundsAsRoi: (ImageProcessor*)imgproc;

@end
