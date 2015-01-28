//
//  CameraSession.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import "CameraSession.h"
using namespace cv;

@interface CameraSession()

@end

@implementation CameraSession


+ (CameraSession *) initWithPreview:(UIView *)view {
    CameraSession* session = [[CameraSession alloc] init];
    
    UIImageView *preview = [[UIImageView alloc] initWithFrame:view.bounds];
    
    session.videoCamera = [[FixedCvCamera alloc] init];
    session.videoCamera.parentView = preview;
    session.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    session.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    session.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    session.videoCamera.defaultFPS = 30;
    session.videoCamera.grayscaleMode = NO;
    session.videoCamera.delegate = session;
    
    [view addSubview:preview];

    return session;
}


- (void)startCameraSession {
    [self.videoCamera start];
}

- (float)getAspectRatio {
    if (self.videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1920x1080) {
        return 1920.0 / 1080.0;
    } else if (self.videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1280x720) {
        return 1280.0 / 720.0;
    } else {
        return 4.0 / 3.0;
    }
}

#pragma mark - Protocol CvVideoCameraDelegate

- (void)processImage:(Mat&)image {
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGR2GRAY);
    
    // invert image
    bitwise_not(image_copy, image);
    
    //Convert BGR to BGRA (three channel to four channel)
    /*Mat bgr;
    cvtColor(image_copy, bgr, COLOR_GRAY2BGR);
    
    cvtColor(bgr, image, COLOR_BGR2BGRA);*/
}


@end
