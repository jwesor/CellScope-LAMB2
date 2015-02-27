//
//  IPImageCapture.h
//  LAMB2
//
//  Image processor that will save every frame (Mat) that it
//  sees into the PhotoAlbum that it is given.
//
//  Created by Fletcher Lab Mac Mini on 2/26/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProcessor.h"

@interface IPImageCapture : ImageProcessor

+ (id) initWithAlbum: (id) album;

@end
