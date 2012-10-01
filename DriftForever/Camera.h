//
//  Camera.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Camera : NSObject

@property (assign) float  initX;
@property (assign) float  initY;
@property (assign) float  initZ;
@property (assign) float  initEyeX;
@property (assign) float  initEyeY;
@property (assign) float  initEyeZ;

+ (Camera*) getObject;
+ (void) initCameraWithLayer: (CCLayer*) layer;

- (void) moveCameraByPoint: (CGPoint) point;
- (void) setCameraToPoint: (CGPoint) point;

@end
