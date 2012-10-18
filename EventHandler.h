//
//  EventHandler.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/18/55 BE.
//
//

#import <Foundation/Foundation.h>

@protocol EventHandlerDelegate <NSObject>


@end

@class Event;
@class Combo;
@interface EventHandler : NSObject

- (void) onStart;
- (void) onFinish;
- (void) onUpdate: (float) deltaTime;

@end
