//
//  IPIdleFrames.h
//  LAMB2
//
//  Idles for specified number of frames before
//  notifying delegates. While it subclasses AsyncImageProcessor,
//  it doesn't really do any image processing and can just override
//  all the async stuff.
//
//  Created by Fletcher Lab Mac Mini on 5/14/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "AsyncImageProcessor.h"

@interface IPIdleFrames : AsyncImageProcessor

@property (readonly) int current;
@property int idleFrames;

@end
