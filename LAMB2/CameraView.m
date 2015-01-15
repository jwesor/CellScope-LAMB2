//
//  CameraView.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 11/24/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraView

+ (Class) layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoSession *)session {
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void) setSession:(AVCaptureSession *)session {
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
