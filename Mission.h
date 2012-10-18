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

// Global methods
+ (void) setCurrentMissionCode: (int) missionCode;
+ (int) getCurrentMissionCode;
+ (Mission*) GetMissionFromCode: (int) missionCode;
+ (void) removeAllMissionCache;

// Class methods
- (int) GetStartVertex;
- (int) GetEndVertex;

@end
