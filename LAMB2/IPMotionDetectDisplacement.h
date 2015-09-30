//
//  A displacement tracker that is optimized for frames where
//  motion is rarely expected. Runs cross correlation on a downsampled
//  version of the image, and runs it again on full-size only if it detects
//  movement in the downsampled version.
//
//  If responsiveScaling is set to false, it will always perform this
//  extra step. Otherwise, it will only do so when the previous frame
//  did not detect motion. Once motion has been detected, it will revert to
//  default IPDisplacement behavior, until motion stops again.
//
//  IPMotionDetectDisplacement.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/25/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "IPDisplacement.h"

@interface IPMotionDetectDisplacement : IPDisplacement

@property float scale;
@property int motionThreshold;
@property bool responsiveScaling;

@end
