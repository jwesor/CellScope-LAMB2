//
//  IPBackgroundSubtract.h
//  LAMB2
//
//  The first frame that this image processor is passed will
//  be saved as the background. Every frame it processes afterwards
//  will have the background subtracted from it.
//
//  Calling reset makes it capture a new frame.
//
//  Created by Fletcher Lab Mac Mini on 9/1/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface IPBackgroundSubtract : ImageProcessor

- (void) reset;

@end
