//
//  Fuel.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/19/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ConsoleDelegate <NSObject>

- (void) onStartAccel;
- (void) onFinishAccel;
- (void) onStartBreak;
- (void) onFinishBreak;

@end

@interface Console : NSObject

+ (Console*) getObject;

@property (assign) id<ConsoleDelegate> delegate;

- (void) LoadData;
- (void) UnloadData;

- (void) AssignDataToLayer: (CCLayer*) layer;
- (void) Update: (float) deltaTime;

- (void) SetFuelNorm: (float) fuelNorm; // between 0.0 and 1.0
- (float) GetFuelNorm; // between 0.0 and 1.0

- (void) touchButtonAtPoint: (CGPoint) point;
- (void) touchMoveAtPoint: (CGPoint) point;
- (void) unTouchButtonAtPoint: (CGPoint) point;

- (BOOL) getIsTouchingAccel;
- (BOOL) getIsTouchingBreak;

- (void) hideConsole;
- (void) showConsole;

@end
