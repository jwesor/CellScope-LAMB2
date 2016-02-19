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

@property int blocksize;
@property int c;
@property (readonly) int detectedCount;
@property int minsize;
@property int maxsize;

- (ContourTrackable) getDetectedTrackable: (int)index;

@end
