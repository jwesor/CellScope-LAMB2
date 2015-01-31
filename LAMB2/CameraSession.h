//
//  CameraSession.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif
#import <opencv2/highgui/cap_ios.h>
#import "FixedCvCamera.h"
#import "ImageProcessor.h"


@interface CameraSession : NSObject <CvVideoCameraDelegate> {
    CvVideoCamera *_videoCamera;
    NSMutableArray *processors;
}
@property (nonatomic, retain) CvVideoCamera* videoCamera;

+ (CameraSession *) initWithPreview: (UIView*) view;

- (void) startCameraSession;

- (void) addImageProcessor: (ImageProcessor *) imgproc;

@end