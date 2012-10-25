//
//  ComboPlayer.h
//  DriftForever
//
//  Created by ADAWAT on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Combo.h"

@protocol ComboPlayerDelegate <NSObject>

- (void) onComboFinished: (Combo*) combo isSuccess: (BOOL) isSuccess;

@end

@interface ComboPlayer : NSObject

+ (ComboPlayer*) getObject;

@property (assign) id<ComboPlayerDelegate> delegate;

- (void) LoadData;
- (void) UnloadData;

- (void) startCombo: (Combo*) combo;
- (void) finishCombo: (BOOL) isSuccess;
- (BOOL) isPlayingCombo;

- (void) AssignDataToLayer: (CCLayer*) layer;
- (void) Update: (float) deltaTime;

- (void) touchButtonAtPoint: (CGPoint) point;

@end
