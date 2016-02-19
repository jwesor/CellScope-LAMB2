//
//  CvCameraSession.h
//  LAMB2
//
//  Base camera class that will take every frame and
//  send it to ImageProcessors.
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraSessionProtocol.h"
#import "ImageProcessor.h"
#import "AsyncImageProcessor.h"

@interface CvCameraSession : NSObject<CameraSessionProtocol>

/* enableCapture must be toggled true in order for captureImage to work.
 * Since this will add an extra Mat.clone() call with every frame, leave
 * it false unless the application needs image captures.
 */
@property bool enableCapture;
@property NSOperationQueue *opQueue;
@property (nonatomic, getter = getAutoFocus, setter = setAutoFocus:) bool continuousAutoFocus;
@property (nonatomic, getter = getWhiteBalance, setter = setWhiteBalance:) bool continuousAutoWhiteBalance;
@property (nonatomic, getter = getExposure, setter = setExposure:) bool continuousAutoExposure;
@property (readonly) NSDate *currentFrameTime;

/* Create a new camera session with a preview inside of this view.
 */
+ (CvCameraSession *) initWithPreview: (UIView*) view;


- (void) addImageProcessor: (ImageProcessor *) imgproc;

- (void) addAsyncImageProcessor: (AsyncImageProcessor *) imgproc;

- (void) removeImageProcessor: (ImageProcessor *) imgproc;

/* Convert the current frame into a UIImage for saving or
 * whatever other purposes. enableCapture must be true,
 * else this will return nil.
 */
- (UIImage *) captureImage;

@end