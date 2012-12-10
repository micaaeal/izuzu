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

+ (Mission*) getObject;

// res
- (void) loadData;
- (void) unloadData;
- (void) AssignDataToLayer: (CCLayer*) layer;
- (void) setWinFlagPoint: (CGPoint) point;
- (void) setStarSignPoint: (CGPoint) point;

- (void) setCurrentMissionCode: (int) missionCode;
- (int) getCurrentMissionCode;
- (int) getMissionCount;

- (int) GetStartVertexFromMissionCode: (int) missionCode;
- (int) GetEndVertexFromMissionCode: (int) missionCode;

@end
