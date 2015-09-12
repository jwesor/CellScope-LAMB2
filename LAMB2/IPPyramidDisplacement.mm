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
using namespace cv;
using namespace std;

@interface IPPyramidDisplacement() {
    int _dX, _dY;
    bool _firstFrame;
    
    std::vector<cv::Rect> _searches;
    
    Mat _referenceImg;
    cv::Rect _template;
    cv::Rect _matched;
    cv::Rect _netSearch;
    int _searchLevels;
}
@end

@implementation IPPyramidDisplacement

@synthesize dX = _dX;
@synthesize dY = _dY;
@synthesize searchLevels = _searchLevels;
@synthesize searchWidth;
@synthesize searchHeight;

- (id) init {
    self = [super init];
    
    _firstFrame = true;
    _searchLevels = 4;
    
    self.templateWidth = 200;
    self.templateHeight = 200;
    
    self.searchWidth = 48;
    self.searchHeight = 48;
    
    return self;
}

- (void) processImage: (Mat&) image {
    if (_firstFrame) {
        float ratio = MIN(image.cols / float(self.searchWidth+self.templateWidth),
                          image.rows / float(self.searchHeight+self.templateHeight));
        _searchLevels = MAX(1, MIN(int(log2(ratio))+1, _searchLevels));
        NSLog(@"%d", _searchLevels);
        //        int scale = pow(2, _searchLevels);
        //        int completeWidth = self.templateWidth * scale + self.searchWidth;
        //        int completeHeight = self.templateHeight * scale + self.searchHeight;
        //        _netSearch = cv::Rect(image.cols / 2 - completeWidth / 2,
        //                              image.rows / 2 - completeHeight / 2,
        //                              completeWidth,
        //                              completeHeight);
    }
    Mat img_gray;
    cvtColor(image, img_gray, CV_BGRA2GRAY);
    if (_firstFrame) {
        _referenceImg = img_gray;
        _firstFrame = false;
    }
    
    std::vector<Mat> _templatePyramid;
    std::vector<Mat> _referencePyramid;
    buildPyramid(img_gray, _templatePyramid, _searchLevels);
    buildPyramid(_referenceImg, _referencePyramid, _searchLevels);
    
    Mat imgTemplate;
    Mat imgReference;
    Mat tmpl;
    Mat refr;
    int originX = 0;
    int originY = 0;
    int deltaX = 0;
    int deltaY = 0;
    double minVal;
    double maxVal;
    cv::Point minLoc;
    cv::Point maxLoc;
    cv::Point matchLoc;
    Mat corrResults;
    _searches.clear();
    for (int i = _searchLevels - 1; i >= 0; i--) {
        imgTemplate = _templatePyramid[i];
        imgReference = _referencePyramid[i];
        
        if (i == _searchLevels - 1) {
            originX = imgTemplate.cols / 2;
            originY = imgTemplate.rows / 2;
        } else {
            originX *= 2;
            originY *= 2;
        }
        
        int searchRegionWidth = self.templateWidth + self.searchWidth;
        int searchRegionHeight = self.templateHeight + self.searchHeight;
        int searchW = searchRegionWidth;
        int searchH = searchRegionHeight;
        originX = MIN(imgTemplate.cols - searchW / 2, MAX(originX, searchW / 2));
        originY = MIN(imgTemplate.rows - searchH / 2, MAX(originY, searchH / 2));
        int searchX = originX - searchRegionWidth / 2;
        int searchY = originY - searchRegionHeight / 2;
        cv::Rect search = cv::Rect(searchX, searchY, searchW, searchH);
        _template = cv::Rect(searchX + self.searchWidth / 2, searchY + self.searchHeight / 2,
                             self.templateWidth, self.templateHeight);
        tmpl = Mat(imgTemplate, _template);
        refr = Mat(imgReference, search);
        
        corrResults.create(search.width - _template.width + 1, search.height - _template.height + 1, CV_32FC1);
        matchTemplate(refr, tmpl, corrResults, TM_CCORR_NORMED);
        minMaxLoc(corrResults, &minVal, &maxVal, &minLoc, &maxLoc, Mat());
        deltaX = self.searchWidth / 2 - maxLoc.x;
        deltaY = self.searchHeight / 2 - maxLoc.y;
        originX += deltaX;
        originY += deltaY;
        
        int scale = pow(2, i);
        search.x *= scale;
        search.y *= scale;
        search.width *= scale;
        search.height *= scale;
        _searches.push_back(search);
    }
    _matched = cv::Rect(deltaX + _template.x, deltaY + _template.y,
                        _template.width, _template.height);
    
    _dX = deltaX;
    _dY = deltaY;
    _referenceImg = img_gray;
    _templatePyramid.clear();
    _referencePyramid.clear();
}

- (void) updateDisplayOverlay:(Mat &)image {
    Scalar color = Scalar(0, 255, 0, 255);
    for (cv::Rect search: _searches) {
        rectangle(image, search, Scalar(0, 255, 255, 255));
    }
    rectangle(image, _template, color);
    rectangle(image, _matched, Scalar(255, 255, 0, 255));
}

- (void) reset {
    _firstFrame = true;
}

@end

