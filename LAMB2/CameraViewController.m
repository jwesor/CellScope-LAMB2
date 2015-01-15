//
//  CameraViewController.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 11/24/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    session = [CameraSession initWithPreview:preview];
    [session startCameraSession];
}

@end
