//
//  CvImageUtils.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/26/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

@interface CvImageUtils : NSObject

// Convert a Mat to UIImage. Note that calling this method will
// flip the arg Mat's colorspace from BGR to RGB.
+ (UIImage*) imageWithCVMat:(cv::Mat&)cvMat;

@end
