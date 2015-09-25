//
//  Import to get access to the outwards-facing image
//  processing methods.
//
//  ImageProcessor+CvInterface.hpp
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/25/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageProcessor(CvInterface)
- (void) process: (cv::Mat&)image;
- (void) display: (cv::Mat&)image;
@end