//
//  LinePlotter.h
//  PathPlotter
//
//  Created by Adawat Chanchua on 2/25/56 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LinePlotter : NSObject

- (void) start;
- (void) shutdown;

- (void) clear;
- (void) begineWithPoint: (CGPoint) point;
- (void) addPoint: (CGPoint) point;
- (void) end;

- (void) onDraw;
- (void) onDrawWithViewport:(CGPoint) vp andCamZoom:(float)zoom;

- (CGPoint) getLastPoint;
- (CCRenderTexture*) getRenderTexture;

@end
