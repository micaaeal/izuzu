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

@property (copy) NSString*      code;
@property (assign) CGPoint      point;
@property (copy) NSString*      typeName;
@property (copy) NSString*      eventName;
@property (retain) CCSprite*    sprite;
@property (assign) BOOL         isTouching;
@property (retain) NSMutableArray*  eventBlockCodeArray;

@end
