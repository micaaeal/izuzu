//
//  Event.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/12/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Event : NSObject

@property (copy) NSString*          code;
@property (assign) CGPoint          point;
@property (copy) NSString*          eventName;
@property (assign) BOOL             isTouching;

@property (retain) NSArray*         comboList;
@property (copy) NSString*          comboTime;

@property (retain) CCSprite*        sprite;

@end
