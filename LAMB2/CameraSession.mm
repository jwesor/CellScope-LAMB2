//
//  CameraSession.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import "CameraSession.h"
#import "ImageProcessor+CvInterface.hpp"
#import <opencv2/videoio/cap_ios.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageUtils.hpp"
using namespace cv;

// As of OpenCV 3.0, CvVideoCameraDelegate implementation needs to be done internally
// so that CameraSession itself does not need to implement the protocol.
// This is to prevent CameraSession.h from having to import any opencv libraries,
// which would otherwise cause issues when bridging CameraSession.h to Swift.

@interface CameraVideoProcessor : NSObject <CvVideoCameraDelegate> {
    UIImage *_capturedImage;
    Mat _currentImg;
    bool _capturedDirty;
    NSMutableArray *_processors;
    CameraSession *_parent;
    NSDate *_currentTime;
}

@property NSMutableArray *processors;
@property CameraSession *parent;
@proeprty NSDate *currentFrameTime = _currentTime;

- (UIImage *) captureImage;

@end


@interface CameraSession() {    bool started;
    CvVideoCamera *_videoCamera;
    CameraVideoProcessor *_videoProcessor;
    NSMutableArray *_processors;
    UIImageView *_imageView;
    AVCaptureDevice *_device;
}

- (void) bindVideoProcessor:(CameraVideoProcessor *) cvp;

@end


@implementation CameraSession

@synthesize enableCapture;
@synthesize opQueue;
@synthesize continuousAutoFocus = _autofocus;
@synthesize continuousAutoWhiteBalance = _autowhite;
@synthesize continuousAutoExposure = _autoexpose;
@synthesize captureDevice = _device;

+ (CameraSession *) initWithPreview:(UIView *)view {
    CameraSession *session = [[CameraSession alloc] init];
    
    UIImageView *preview = [[UIImageView alloc] initWithFrame:view.bounds];
    session->_imageView = preview;
    session->_videoProcessor = [[CameraVideoProcessor alloc] init];
    [session bindVideoProcessor:session->_videoProcessor];
    session->_videoCamera = [[CvVideoCamera alloc] init];
    session->_videoCamera.parentView = preview;
    session->_videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    session->_videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    session->_videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    session->_videoCamera.defaultFPS = 30;
    session->_videoCamera.grayscaleMode = NO;
    session->_videoCamera.delegate = session->_videoProcessor;
    session->_videoCamera.rotateVideo = false;
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
    _autoexpose = true;
    started = false;
    return self;
}

- (void) bindVideoProcessor:(CameraVideoProcessor *)cvp {
    cvp.processors = _processors;
    cvp.parent = self;
}

- (void) startCameraSession {
    [_videoCamera start];
    started = true;
    self.continuousAutoFocus = _autofocus;
    self.continuousAutoWhiteBalance = _autowhite;
    self.continuousAutoExposure = _autoexpose;
}

- (float) getAspectRatio {
    if (_videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1920x1080) {
        return 1920.0 / 1080.0;
    } else if (_videoCamera.defaultAVCaptureSessionPreset == AVCaptureSessionPreset1280x720) {
        return 1280.0 / 720.0;
    } else {
        return 4.0 / 3.0;
    }
}

- (void) addImageProcessor: (ImageProcessor*) imgproc {
    @synchronized(_processors) {
        [_processors addObject:imgproc];
    }
}

- (void) addAsyncImageProcessor:(AsyncImageProcessor *) imgproc {
    imgproc.queue = opQueue;
    @synchronized(_processors) {
        [_processors addObject:imgproc];
    }
}

- (void) removeImageProcessor:(ImageProcessor *)imgproc {
    @synchronized(_processors) {
        [_processors removeObject:imgproc];
    }
}

- (UIImage *) captureImage {
    @synchronized (self) {
        if (!enableCapture) {
            return nil;
        } else {
            return [_videoProcessor captureImage];
        }
    }
}

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

- (void) setExposure:(bool)continuousAutoExposure {
    NSError *error = nil;
    AVCaptureDevice *device = self.captureDevice;
    if (device == nil) {
        _autoexpose = continuousAutoExposure;
        return;
    }
    if ([device lockForConfiguration:&error]) {
        if (!continuousAutoExposure && [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            device.exposureMode = AVCaptureExposureModeLocked;
            [device unlockForConfiguration];
            _autoexpose = continuousAutoExposure;
        } else if (continuousAutoExposure && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            [device unlockForConfiguration];
            _autoexpose = continuousAutoExposure;
        }
    } else {
        NSLog(@"unable to lock device for auto exposure configuration %@", [error localizedDescription]);
    }
}

- (bool) getExposure {
    AVCaptureDevice *device = self.captureDevice;
    if (device != nil) {
        _autoexpose = device.exposureMode == AVCaptureExposureModeContinuousAutoExposure;
    }
    return _autoexpose;
}

- (bool) doSingleAutoExposure {
    if (self.continuousAutoExposure)
        return true;
    AVCaptureDevice *device = self.captureDevice;
    NSError *error = nil;
    if (device == nil)
        return false;
    if ([device lockForConfiguration:&error]) {
        if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            device.exposureMode = AVCaptureExposureModeAutoExpose;
            [device unlockForConfiguration];
            return true;
        }
    } else {
        NSLog(@"unable to lock device for exposure configuration %@", [error localizedDescription]);
    }
    return false;
}
@end

@implementation CameraVideoProcessor

@synthesize processors = _processors;
@synthesize parent = _parent;

#pragma mark - Protocol CvVideoCameraDelegate

- (void) processImage:(Mat&)image {
    _currentTime = [NSDate date];

    // Do some OpenCV stuff with the image
    if (_parent.enableCapture) {
        @synchronized (_parent) {
            _currentImg = image.clone();
            _capturedDirty = true;
        }
    }
    
    @synchronized (_processors) {
        for (ImageProcessor *imgproc in _processors) {
            if (imgproc.enabled) {
                imageProcess.currentFrameTime = _currentTime;
                [imgproc process:image];
            }
        }
        
        for (ImageProcessor *imgproc in _processors) {
            if (imgproc.enabled && imgproc.displayEnabled) {
                [imgproc display:image];
            }
        }
    }
}

- (UIImage *) captureImage {
    if (_capturedDirty) {
        _capturedImage = [ImageUtils imageWithCVMat:_currentImg];
        _capturedDirty = false;
    }
    return _capturedImage;
}

@end