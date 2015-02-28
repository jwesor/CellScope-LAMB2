//
//  IPFocusDetector.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/27/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface IPFocusDetector : ImageProcessor

@property (readonly) int focus;

@property double lowerThreshold;

@property double upperThreshold;

@end
