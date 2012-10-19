//
//  Fuel.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/19/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Fuel : NSObject

+ (Fuel*) getObject;

- (void) LoadData;
- (void) UnloadData;

- (void) AssignDataToLayer: (CCLayer*) layer;
- (void) Update: (float) deltaTime;

- (void) SetFuelNorm: (float) fuelNorm; // between 0.0 and 1.0
- (float) GetFuelNorm; // between 0.0 and 1.0

@end
