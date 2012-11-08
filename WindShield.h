//
//  WindShield.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/8/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WindShield : NSObject

+ (WindShield*) getObject;

- (void) onStart;
- (void) onFinish;

- (void) assignDataToLayer: (CCLayer*) layer;

- (void) onUpdate: (float) deltaTime;

// wind shield objects
- (BOOL) hasAnythingOnWindshield;
- (void) clearAllVisionBarrier;

- (void) showWater;
- (BOOL) getIsShowingWater;
- (void) clearWater;

@end
