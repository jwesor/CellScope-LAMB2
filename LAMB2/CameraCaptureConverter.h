//
//  CameraCaptureConverter.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 11/21/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/core/core_c.h>

@interface CameraCaptureConverter : NSObject

+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

#ifdef __cplusplus
+ (void) grayscaleMatFromSampleBuffer:(CMSampleBufferRef)sampleBuffer dstMat:(cv::Mat *)mat;
#endif

@end
