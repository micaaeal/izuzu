//
//  MenuRouteGuide.h
//  DriftForever
//
//  Created by Adawat Chanchua on 2/17/56 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuRouteGuide : NSObject

- (void) loadDataToLayer: (CCLayer*) rootLayer;

- (void) showLight;
- (void) hideLight;
- (void) setLightPoserFrom:(CGPoint) from to:(CGPoint) to;

- (void) showRouteTarget;
- (void) hideRouteTarget;
- (void) setRouteTargetPosition:(CGPoint) position;
- (void) setRouteTargetState: (BOOL) isOnOrOff;

@end
