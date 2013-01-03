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

@protocol EventHandlerDelegate <NSObject>

- (void) onStartEvent: (Event*) event;

@end

@interface EventHandler : NSObject

+ (EventHandler*) getObject;

@property (assign) id<EventHandlerDelegate> delegate;

- (void) onStart;
- (void) onFinish;

- (void) assignDataToActionLayer: (CCLayer*) actionLayer uiLayer: (CCLayer*) uiLayer;

- (void) onUpdate: (float) deltaTime;
- (void) finishAllEvents;

- (void) showSpeedLimitSign;
- (void) hideSpeedLimitSign;

- (BOOL) getIsShowAnyEvent;

- (void) showTurtleOpen;
- (void) hideTurtleOpen;

- (void) showTurtleWalk;
- (void) hideTurtleWalk;

@end
