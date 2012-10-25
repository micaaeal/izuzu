//
//  EventHandler.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/18/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Event.h"
#import "Combo.h"

@protocol EventHandlerDelegate <NSObject>

- (void) onTouchingInWithEvent: (Event*) event isComboSuccess: (BOOL) isComboSuccess;
- (void) onTouchingOutWithEvent: (Event*) event;

- (void) onStartCombo: (Combo*) combo;

@end

@interface EventHandler : NSObject

+ (EventHandler*) getObject;

@property (assign) id<EventHandlerDelegate> delegate;

- (void) onStart;
- (void) onFinish;

- (void) assignDataToLayer: (CCLayer*) layer;

- (void) onUpdate: (float) deltaTime;

- (BOOL) finishCombo: (Combo*) combo;
- (BOOL) hasRegisteredCombo: (Combo*) combo;

@end
