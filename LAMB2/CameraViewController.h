//
//  CameraViewController.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 11/24/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraSession.h"


@interface CameraViewController : UIViewController  {
    IBOutlet UIImageView *preview;
    CameraSession *session;
}
@end