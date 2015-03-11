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
    bool started;
    UIImage *capturedImage;
}
- (void) addImageProcessor: (ImageProcessor *) imgproc;
@end

@implementation CameraSession

@synthesize enableCapture;
@synthesize opQueue;
@synthesize continuousAutoFocus = _autofocus;
@synthesize continuousAutoWhiteBalance = _autowhite;
@synthesize captureDevice = _device;

+ (CameraSession *) initWithPreview:(UIView *)view {
    CameraSession *session = [[CameraSession alloc] init];
    
    UIImageView *preview = [[UIImageView alloc] initWithFrame:view.bounds];
    session->_imageView = preview;
    
    session.videoCamera = [[CvVideoCamera alloc] init];
    session.videoCamera.parentView = preview;
    session.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    session.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    session.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    session.videoCamera.defaultFPS = 30;
    session.videoCamera.grayscaleMode = NO;
    session.videoCamera.delegate = session;
    session.videoCamera.rotateVideo = false;
    session->_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [view addSubview:preview];
    
    return session;
}

- (id) init {
    _processors = [[NSMutableArray alloc] init];
    opQueue = [[NSOperationQueue alloc] init];
    opQueue.maxConcurrentOperationCount = 1;
    _autofocus = true;
    _autowhite = true;
    started = false;
    return self;
}


- (void) startCameraSession {
    [self.videoCamera start];
    started = true;
    self.continuousAutoFocus = _autofocus;
    self.continuousAutoWhiteBalance = _autowhite;
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
    [_processors addObject:imgproc];
}

- (void) addAsyncImageProcessor:(AsyncImageProcessor *) proc {
    if (proc.queue == nil) {
        proc.queue = opQueue;
    }
    [_processors addObject:proc];
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

/* See opencv/modules/videoio/src/cap_ios_abstract_camera.mm for reference on changing
 * autofocus settings.
 */
- (void) setAutoFocus:(bool)continuousAutoFocus {
    NSError *error = nil;
    AVCaptureDevice *device = self.captureDevice;
    if (device == nil) {
        _autofocus = continuousAutoFocus;
        return;
    }
    if ([device lockForConfiguration:&error]) {
        if (!continuousAutoFocus && [device isFocusModeSupported:AVCaptureFocusModeLocked]) {
            device.focusMode = AVCaptureFocusModeLocked;
            [device unlockForConfiguration];
            _autofocus = continuousAutoFocus;
        } else if (continuousAutoFocus && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [device unlockForConfiguration];
            _autofocus = continuousAutoFocus;
        }
    } else {
        NSLog(@"unable to lock device for autofocus configuration %@", [error localizedDescription]);
    }
}

- (bool) getAutoFocus {
    AVCaptureDevice *device = self.captureDevice;
    if (device != nil) {
        _autofocus = device.focusMode == AVCaptureFocusModeContinuousAutoFocus;
    }
    return _autofocus;
}

- (bool) doSingleAutoFocus {
    if (self.continuousAutoFocus)
        return true;
    AVCaptureDevice *device = self.captureDevice;
    NSError *error = nil;
    if (device == nil)
        return false;
    if ([device lockForConfiguration:&error]) {
        if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
            return true;
        }
    } else {
        NSLog(@"unable to lock device for autofocus configuration %@", [error localizedDescription]);
    }
    return false;
}

- (void) setWhiteBalance:(bool)continuousAutoWhiteBalance {
    NSError *error = nil;
    AVCaptureDevice *device = self.captureDevice;
    if (device == nil) {
        _autowhite = continuousAutoWhiteBalance;
        return;
    }
    if ([device lockForConfiguration:&error]) {
        if (!continuousAutoWhiteBalance && [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
            [device unlockForConfiguration];
            _autowhite = continuousAutoWhiteBalance;
        } else if (continuousAutoWhiteBalance && [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            [device unlockForConfiguration];
            _autowhite = continuousAutoWhiteBalance;
        }
    } else {
        NSLog(@"unable to lock device for auto white balance configuration %@", [error localizedDescription]);
    }
}

- (bool) getWhiteBalance {
    AVCaptureDevice *device = self.captureDevice;
    if (device != nil) {
        _autowhite = device.whiteBalanceMode == AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    }
    return _autowhite;
}

- (bool) doSingleAutoWhiteBalance {
    if (self.continuousAutoWhiteBalance)
        return true;
    AVCaptureDevice *device = self.captureDevice;
    NSError *error = nil;
    if (device == nil)
        return false;
    if ([device lockForConfiguration:&error]) {
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            [device unlockForConfiguration];
            return true;
        }
    } else {
        NSLog(@"unable to lock device for white balance configuration %@", [error localizedDescription]);
    }
    return false;
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
    
    for (ImageProcessor *imgproc in _processors) {
        if (imgproc.enabled) {
            [imgproc processImage:image];
        }
    }
    
    for (ImageProcessor *imgproc in _processors) {
        if (imgproc.enabled) {
            [imgproc updateDisplayOverlay:image];
        }
    }
}

@end
