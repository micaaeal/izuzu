//
//  Car.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Mission.h"

@interface Car : NSObject

+ (BOOL) LoadData;
+ (BOOL) UnloadData;

+ (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission;
+ (BOOL) UnSssignDataFromLayer: (CCLayer*) layer;

+ (float) getSpeed;
+ (void) setSpeed: (float) speed;

+ (void) setPosition: (CGPoint&) position;
+ (void) setTarget: (CGPoint&) target;
+ (const CGPoint) getPosition;
+ (const CGFloat) getRotation;
+ (const CGPoint) getTarget;

+ (CGRect) getBoundingBox;

+ (void) setRandomColor;
+ (void) unsetRandomColor;

@end
