//
//  IPDrawTrackables.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/9/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"
#import "IPDetectContourTrackables.h"

@interface IPDrawTrackables : ImageProcessor

- (void) resetToCount: (int)count;
- (void) addTrackable: (ContourTrackable)trackable;

@end
