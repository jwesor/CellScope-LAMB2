//
//  IPPyramidDisplacement.m
//  LAMB2
//
//  Tracks how much the
//
//  Created by Fletcher Lab Mac Mini on 6/7/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPPyramidDisplacement.h"
#import "ImageProcessor+CvExtension.hpp"
using namespace cv;
using namespace std;

@interface IPPyramidDisplacement() {
    IPDisplacement* _subDisplace;
    cv::Rect _upperTemplate;
}
@end

@implementation IPPyramidDisplacement

@synthesize searchPadding;
@synthesize scale;

- (id) init {
    self = [super init];
    _subDisplace = [[IPDisplacement alloc] init];
    
    self.searchPadding = 64;
    self.scale = 0.5;
    self.area = true;
    
    return self;
}

- (void) processImage: (Mat&) image {
    cv::Size targetSize(image.cols * scale, image.rows * scale);
    Mat scaled;
    resize(image, scaled, targetSize);
    [_subDisplace processImage:scaled];
    
    // Find the bounding box for the upper level template location
    int subX1 = int(_subDisplace.templateX / scale);
    int subY1 = int(_subDisplace.templateY / scale);
    int subX2 = int((_subDisplace.templateX + _subDisplace.templateWidth) / scale);
    int subY2 = int((_subDisplace.templateY + _subDisplace.templateHeight) / scale);
    _upperTemplate.x = subX1;
    _upperTemplate.y = subY1;
    _upperTemplate.width = subX2 - subX1;
    _upperTemplate.height = subY2 - subY1;
    
    int originX = (subX1 + subX2) / 2 - self.templateWidth / 2;
    int originY = (subY1 + subY2) / 2 - self.templateHeight / 2;
    
    int x1 = max(originX - searchPadding, 0);
    int y1 = max(originY - searchPadding, 0);
    int x2 = min(x1 + self.templateWidth + searchPadding * 2, image.cols - 1);
    int y2 = min(y1 + self.templateHeight + searchPadding * 2, image.rows - 1);
    
    self.areaX = x1;
    self.areaY = y1;
    self.areaWidth = x2 - x1;
    self.areaHeight = y2 - y1;
    [super processImage:image];
}

- (void) updateDisplayOverlay:(Mat &)image {
    rectangle(image, _upperTemplate, Scalar(0, 255, 255, 0));
    [super updateDisplayOverlay:image];
}

@end

