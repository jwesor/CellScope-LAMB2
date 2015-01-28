//
//  CvCameraFixed.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/28/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import <opencv2/highgui/cap_ios.h>

@interface FixedCvCamera : CvVideoCamera

- (void)updateOrientation;
- (void)layoutPreviewLayer;

@end
