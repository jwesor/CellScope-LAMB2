//
//  Import to give ImageProcessor subclasses access to the
//  processImage and updateDisplayOverlay methods
//
//  ImageProcessor+IPExtension.hpp
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 9/25/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageProcessor(CvExtension)
- (void) processImage: (cv::Mat&)image;
- (void) updateDisplayOverlay: (cv::Mat&)image;
@end