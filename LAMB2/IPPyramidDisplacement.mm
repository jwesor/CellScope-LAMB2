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
    _subDisplace.templateWidth = 100;
    _subDisplace.templateHeight = 100;
    self.searchPadding = 8;
    self.scale = 0.25;
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
    
    self.areaX = (subX2 + subX1) / 2 - self.searchPadding - self.templateWidth / 2;
    self.areaY = (subY2 + subY1) / 2 - self.searchPadding - self.templateHeight / 2;

    self.areaWidth = self.searchPadding * 2;
    self.areaHeight = self.searchPadding * 2;
    
    [super processImage:image];
}

- (void) updateDisplayOverlay:(Mat &)image {
    rectangle(image, _upperTemplate, Scalar(255, 0, 0, 255));
    [super updateDisplayOverlay:image];
}

@end

