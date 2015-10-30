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
    self.searchPadding = 8;
    self.scale = 0.25;
    _subDisplace.templateWidth = self.templateWidth * self.scale;
    _subDisplace.templateHeight = self.templateHeight * self.scale;
    NSLog(@"%d %d %d %d", _subDisplace.templateWidth, _subDisplace.templateHeight, self.templateWidth, self.templateHeight);
    self.area = true;
    
    return self;
}

- (void) processImage: (Mat&) image {
    cv::Size targetSize(image.cols * scale, image.rows * scale);
    Mat scaled;
    resize(image, scaled, targetSize);
    [_subDisplace processImage:scaled];
    
    // Find the bounding box for the upper level template location
    int subX1 = int((_subDisplace.templateX - _subDisplace.dX) / scale);
    int subY1 = int((_subDisplace.templateY - _subDisplace.dY) / scale);
    int subX2 = int((_subDisplace.templateX + _subDisplace.templateWidth) / scale);
    int subY2 = int((_subDisplace.templateY + _subDisplace.templateHeight) / scale);
    _upperTemplate.x = subX1;
    _upperTemplate.y = subY1;
    _upperTemplate.width = subX2 - subX1;
    _upperTemplate.height = subY2 - subY1;
    
    self.areaX = MAX(0, (subX2 + subX1) / 2 - self.searchPadding - self.templateWidth / 2);
    self.areaY = MAX(0, (subY2 + subY1) / 2 - self.searchPadding - self.templateHeight / 2);

    self.areaWidth = self.searchPadding * 2;
    self.areaHeight = self.searchPadding * 2;
    
    [super processImage:image];
}

- (void) updateDisplayOverlay:(Mat &)image {
    rectangle(image, _upperTemplate, Scalar(255, 0, 0, 255));
    [super updateDisplayOverlay:image];
}

- (void) reset {
    [super reset];
    [_subDisplace reset];
}

- (void) setUpdateTemplate:(bool)updateTemplate {
    [super setUpdateTemplate:updateTemplate];
    [_subDisplace setUpdateTemplate:updateTemplate];
}

- (void) setTrackTemplate:(bool)trackTemplate {
    [super setTrackTemplate:trackTemplate];
    [_subDisplace setTrackTemplate:trackTemplate];
}

- (void) setGrayscale:(bool)grayscale {
    [super setGrayscale:grayscale];
    [_subDisplace setGrayscale:grayscale];
}

- (void) setTemplateWidth:(int)templateWidth {
    [super setTemplateWidth:templateWidth];
    _subDisplace.templateWidth = templateWidth * scale;
}

- (void) setTemplateHeight:(int)templateHeight {
    [super setTemplateHeight:templateHeight];
    _subDisplace.templateHeight = templateHeight * scale;
}

@end

