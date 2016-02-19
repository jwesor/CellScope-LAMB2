//
//  CameraSessionProtocol.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/13/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraSessionProtocol

@required

- (void) startCameraSession;
- (void) stopCameraSession;

@property (readonly) bool started;
@property (readonly) AVCaptureDevice *captureDevice;


@end