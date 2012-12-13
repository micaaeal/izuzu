//
//  Mission.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol MissionDelegate

- (void) onGettingOrder:(id)sender
             totalOrder:(int)total
              gottOrder:(int)gotOrder;

@end

@class Order;
@interface Mission : NSObject

+ (Mission*) getObject;

@property (assign) id<MissionDelegate> delegate;

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

- (Order*) GetORderFromMissionCode: (int) missionCode;

- (void) SetMapLayer: (CCLayer*) mapLayer;
- (void) AddBoxSpriteToMapLayerAtPosition: (CGPoint) position;
- (void) ClearAllBoxSpritesFromMapLayer;
- (void) HideBoxSpriteFromMapLayerByPosition: (CGPoint) position;

- (void) Update: (float) dt;

@end
