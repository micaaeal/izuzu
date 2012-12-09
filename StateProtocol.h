//
//  StateProtocol.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol StateProtocol <NSObject>

@property (assign) CCLayer* layer;

- (void) onStart;
- (void) onFinish;
- (void) onRestart;
- (BOOL) onUpdate: (float) deltaTime; // if retuen YES, means end current state
- (void) onRender;
- (BOOL) onTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void) onTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void) onTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

- (void) onGetStringMessage: (NSString*) message;

@end
