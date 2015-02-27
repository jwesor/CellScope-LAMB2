//
//  IPImageCapture.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/26/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "IPImageCapture.h"
#import "ImageUtils.h"
#import "LAMB2-Swift.h"
using namespace cv;

@interface IPImageCapture()
@property PhotoAlbum *album;

@end

@implementation IPImageCapture

@synthesize album;

+ (id) initWithAlbum:(PhotoAlbum *)album {
    IPImageCapture *ic = [[IPImageCapture alloc] init];
    ic.album = album;
    NSLog(@"init album %@ %@", album, ic.album);
    return ic;
}

- (void) processImage: (Mat&)image {
    NSLog(@"album %@", album);
    if (album != nil) {
        Mat mat = image.clone();
        UIImage *uiimage = [ImageUtils imageWithCVMat:mat];
        [album savePhoto:uiimage];
    } else {
        NSLog(@"IPImageCapture: No album was set.");
    }
}

@end
