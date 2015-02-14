//
//  ImageProcessor.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 1/30/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//


#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@interface ImageProcessor: NSObject {
    bool _enabled;
}

@property bool enabled;

#ifdef __cplusplus
- (void) processImage: (cv::Mat&)image;
- (void) updateDisplayOverlay: (cv::Mat&)image;
#endif

@end