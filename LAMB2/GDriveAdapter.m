//
//  GDriveAdapter.m
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 4/6/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

#import "GDriveAdapter.h"

#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"

// Constants for OAuth 2.0
static NSString * const kKeychainItemName = @"LAMB2: Google Drive";
static NSString * const kClientId = @"282034998393-6o1hivmft9aqcn98db8b26qklhvmit1e.apps.googleusercontent.com";
static NSString * const kClientSecret = @"b03yxOKVXWCWfcfkDBmNNlx6";

@interface GDriveAdapter() {
    NSMutableArray *statusDelegates;
}
@property (readonly, weak) GTLServiceDrive *driveService;
@end

@implementation GDriveAdapter
@synthesize isAuthorized = _isAuthorized;
@synthesize authSignInViewController;

- (id) init {
    self = [super init];
    statusDelegates = [[NSMutableArray alloc] init];
    // Check for authorization.
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientId clientSecret:kClientSecret];
    
    if ([auth canAuthorize]) {
        [self.driveService setAuthorizer:auth];
        self.isAuthorized = true;
    }
    return self;
}

- (void) authSignOut {
    [self.driveService setAuthorizer:nil];
    self.isAuthorized = false;
    for (id<GDriveAdapterStatusDelegate> delegate in statusDelegates) {
        [delegate onDriveSignOut];
    }
}

- (UIViewController *) getAuthSignInViewController {
    SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
    GTMOAuth2ViewControllerTouch *authViewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile clientID:kClientId clientSecret:kClientSecret keychainItemName:kKeychainItemName delegate:self finishedSelector:finishedSelector];
    return authViewController;
}

- (void) viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    bool success = error == nil;
    if (success) {
        //Sign in succeeded
        self.isAuthorized = true;
        [self.driveService setAuthorizer:auth];
    }
    for (id<GDriveAdapterStatusDelegate> delegate in statusDelegates) {
        [delegate onDriveSignIn:success];
    }
}

- (void) addStatusDelegate:(id<GDriveAdapterStatusDelegate>)delegate {
    [statusDelegates addObject:delegate];
}


- (GTLServiceDrive *)driveService {
    static GTLServiceDrive *service = nil;
    if (!service) {
        service = [[GTLServiceDrive alloc] init];
        service.shouldFetchNextPages = YES;
        service.retryEnabled = YES;
    }
    return service;
}

@end
