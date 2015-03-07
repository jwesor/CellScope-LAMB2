//
//  CameraSession.h
//  LAMB2
//
//  Base camera class that will take every frame and
//  send it to ImageProcessors.
//
//  Created by Fletcher Lab Mac Mini on 12/2/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
#import "AsyncImageProcessor.h"

@interface CameraSession : NSObject <CvVideoCameraDelegate> {
    CvVideoCamera *_videoCamera;
    NSMutableArray *processors;
    UIImageView *imageView;
}

/* enableCapture must be toggled true in order for captureImage to work.
 * Since this will add an extra Mat.clone() call with every frame, leave
 * it false unless the application needs image captures.
 */
@property bool enableCapture;
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property NSOperationQueue *opQueue;

/* Create a new camera session with a preview inside of this view.
 */
+ (CameraSession *) initWithPreview: (UIView*) view;

- (void) startCameraSession;

- (void) addImageProcessor: (ImageProcessor *) imgproc;

- (void) addAsyncImageProcessor: (AsyncImageProcessor *) imgproc;

/* Convert the current frame into a UIImage for saving or
 * whatever other purposes. enableCapture must be true,
 * else this will return nil.
 */
- (UIImage *) captureImage;

@end