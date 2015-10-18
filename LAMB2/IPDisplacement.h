//
//  IPDisplacement.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface IPDisplacement : ImageProcessor

@property (nonatomic) int areaWidth;
@property (nonatomic) int areaHeight;
@property (nonatomic) int areaX;
@property (nonatomic) int areaY;
@property bool area;

@property (readonly) int dY;
@property (readonly) int dX;

@property (nonatomic) int templateWidth;
@property (nonatomic) int templateHeight;
@property (readonly) int templateX;
@property (readonly) int templateY;

@property bool grayscale;
@property bool updateFrame;

- (void) reset;

@end
