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

@property (nonatomic) int regionWidth;
@property (nonatomic) int regionHeight;
@property (nonatomic) int cropWidth;
@property (nonatomic) int cropHeight;
@property (nonatomic) int cropX;
@property (nonatomic) int cropY;
@property bool croppingEnabled;
@property bool croppingCentered;

- (void) reset;

@end
