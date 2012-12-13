//
//  MenuSelectRoute.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol MenuSelectRoute <NSObject>

- (void) onTouchButtonAtId: (int) buttonId;

@end

@interface MenuSelectRoute : NSObject

@property (assign) int routeCount;

- (void) loadButtonAtPoint: (CGPoint) point routeCount: (int) routeCount rootLayer: (CCLayer*) rootLayer;
- (void) setButtonAtPoint: (CGPoint) point;
- (void) setRouteButtonDirectTo: (CGPoint) point
                    buttonIndex: (int) buttonIndex;

- (void) setActionObject: (id<MenuSelectRoute>) sender;
- (void) checkActionByPoint: (CGPoint) point;

- (void) hideButtonAtIndex: (int) buttonIndex;
- (void) showButtonAtIndex: (int) buttonIndex;

- (void) hideAllButtons;
- (void) showAllButtons;

@end
