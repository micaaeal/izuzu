//
//  ComboPlayer.h
//  DriftForever
//
//  Created by ADAWAT on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Event.h"

@protocol ComboPlayerDelegate <NSObject>

- (void) onEventFinished: (Event*) event isSuccess: (BOOL) isSuccess;

@end

@interface ComboPlayer : NSObject

+ (ComboPlayer*) getObject;

@property (assign) id<ComboPlayerDelegate> delegate;

- (void) LoadData;
- (void) UnloadData;

- (void) startOverShootEvent;
- (void) startEvent: (Event*) event;
- (void) finishEvent: (BOOL) isSuccess;
- (BOOL) isPlayingEvent;

- (void) AssignDataToLayer: (CCLayer*) layer;
- (void) Update: (float) deltaTime realTime: (float) realTime;

- (void) touchButtonAtPoint: (CGPoint) point;

@end
