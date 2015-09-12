//
//  IPDisplacement.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface IPDisplacement : ImageProcessor

@property (readonly) int dY;
@property (readonly) int dX;

@property int templateWidth;
@property int templateHeight;

@property int searchWidth;
@property int searchHeight;
@property int searchLevels;

- (void) reset;

@end
