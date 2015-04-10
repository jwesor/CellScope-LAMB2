//
//  GDriveAdapter.h
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDriveAdapterStatusDelegate

- (void) onDriveSignIn: (bool)success;
- (void) onDriveSignOut;

@end

@interface GDriveAdapter : NSObject

@property bool isAuthorized;
@property (readonly) UIViewController* authSignInViewController;

- (void) authSignOut;

- (void) addStatusDelegate: (id<GDriveAdapterStatusDelegate>) delegate;

- (UIViewController *) getAuthSignInViewController;

@end
