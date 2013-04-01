//
//  AppDelegate.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/22/55 BE.
//  Copyright __MyCompanyName__ 2555. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "StartMenuViewController.h"
#import "GameFlowSignal.h"
#import "GamePlayViewController.h"
#import "PlayDriftLayer.h"
#import "RootViewController.h"
#import "LoadingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AuthenApp.h"

extern NSString *const FBSessionStateChangedNotification;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, StartMenuViewDelegate, GameFlowSignalDelegate, PlayDriftLayerDelegate, GamePlayViewDelegate, AuthenAppDelegate>

@property (nonatomic, retain) UIWindow *window;

@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

// FBSample logic
// The app delegate is responsible for maintaining the current FBSession. The application requires
// the user to be logged in to Facebook in order to do anything interesting -- if there is no valid
// FBSession, a login screen is displayed.
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
