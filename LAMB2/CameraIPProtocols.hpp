//
//  CameraIPProtocols.hpp
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 7/24/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#ifndef LAMB2_CameraIPProtocols_hpp
#define LAMB2_CameraIPProtocols_hpp

// The methods defined by these protocols were originally declared
// as part of the ImageProcessor and AsyncImageProcessor interface.
// As of OpenCV 3.0, because ImageProcessor.h and AsyncImageProcessor.h
// are bridged to Swift, the interfaces can no longer be allowed to import
// opencv libraries. These declarations have been moved to these internally
// used protocols to avoid this issue.

@protocol ImageProcessorProtocol
- (void) process: (cv::Mat&)image;
- (void) display: (cv::Mat&)image;
@end
#endif

