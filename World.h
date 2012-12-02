//
//  World.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Mission.h"

class RouteGraph;
@interface World : NSObject

+ (World*) getObject;

- (BOOL) LoadData;
- (BOOL) UnloadData;

- (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission;
- (BOOL) UnSssignDataFromLayer: (CCLayer*) layer;

- (RouteGraph&) GetRouteGraph;

- (void) Draw;

@end
