//
//  Mission.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Mission : NSObject

// res
+ (void) loadData;
+ (void) unloadData;
+ (void) AssignDataToLayer: (CCLayer*) layer;
+ (void) setWinFlagPoint: (CGPoint) point;
+ (void) setStarSignPoint: (CGPoint) point;

// Global methods
+ (void) setCurrentMissionCode: (int) missionCode;
+ (int) getCurrentMissionCode;
+ (Mission*) GetMissionFromCode: (int) missionCode;
+ (void) removeAllMissionCache;

// Class methods
- (int) GetStartVertex;
- (int) GetEndVertex;

@end
