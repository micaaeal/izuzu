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
#import "LinePlotter.h"

class RouteGraph;
@interface World : NSObject

+ (World*) getObject;

- (BOOL) LoadRoads;
- (BOOL) LoadBuilings;
- (BOOL) UnloadData;

- (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission;
- (BOOL) UnSssignDataFromLayer: (CCLayer*) layer;

- (RouteGraph&) GetRouteGraph;

- (void) Draw;

- (void) showAllPaths;
- (void) hideAllPaths;

- (void) generatePathsFromRoute;
- (void) clearGeneratedPaths;

- (LinePlotter*) getLinePlotter;

@end
