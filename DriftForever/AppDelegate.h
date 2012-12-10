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

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, StartMenuViewDelegate, GameFlowSignalDelegate, PlayDriftLayerDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (retain) UIViewController* rootViewController;

@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
