//
//  IPDetectContourTrackables.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 10/28/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

typedef struct _ContourTrackable {
    int x;
    int y;
    int width;
    int height;
} ContourTrackable;


@interface IPDetectContourTrackables : ImageProcessor

@property int threshold;
@property (readonly) int detectedCount;

- (ContourTrackable) getDetectedTrackable: (int)index;

@end
