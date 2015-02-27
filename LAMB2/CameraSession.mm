//
//  CameraSession.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import "CameraSession.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageUtils.h"
using namespace cv;

@interface CameraSession() {
    Mat currentImg;
    bool capturedDirty;
    UIImage *capturedImage;
}
- (void) addImageProcessor: (ImageProcessor *) imgproc;
@end

@implementation CameraSession

@synthesize enableCapture;

+ (CameraSession *) initWithPreview:(UIView *)view {
    CameraSession *session = [[CameraSession alloc] init];
    
    UIImageView *preview = [[UIImageView alloc] initWithFrame:view.bounds];
    session->imageView = preview;
    
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

- (id) init {
    processors = [[NSMutableArray alloc] init];
    return self;
}


- (void) startCameraSession {
    [self.videoCamera start];
}

- (float) getAspectRatio {
    if (self.videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1920x1080) {
        return 1920.0 / 1080.0;
    } else if (self.videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1280x720) {
        return 1280.0 / 720.0;
    } else {
        return 4.0 / 3.0;
    }
}

- (void) addImageProcessor: (ImageProcessor*) imgproc {
    [processors addObject:imgproc];
}

- (UIImage *) captureImage {
    @synchronized (self) {
        if (!enableCapture) {
            return nil;
        } else if (capturedDirty) {
            capturedImage = [ImageUtils imageWithCVMat:currentImg];
            capturedDirty = false;
        }
        return capturedImage;

    }
}

#pragma mark - Protocol CvVideoCameraDelegate

- (void) processImage:(Mat&)image {
    // Do some OpenCV stuff with the image
    
    if (enableCapture) {
        @synchronized (self) {
            currentImg = image.clone();
            capturedDirty = true;
        }
    }
    
    for (ImageProcessor *imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc processImage:image];
        }
    }
    
    for (ImageProcessor *imgproc in processors) {
        if (imgproc.enabled) {
            [imgproc updateDisplayOverlay:image];
        }
    }
}

@end
