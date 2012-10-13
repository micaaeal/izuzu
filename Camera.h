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

+ (Camera*) getObject;
- (void) initCameraWithLayer: (CCLayer*) layer;

- (void) moveCameraByPoint: (CGPoint) point;
- (void) setCameraToPoint: (CGPoint) point;

- (CGPoint) getPoint;
- (CGFloat) getZoomX;

- (void) zoomTo: (CGFloat) zoomX;
- (void) onUpdate: (float) deltaTime;

@end
