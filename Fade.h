//
//  Fade.h
//  DriftForever
//
//  Created by Adawat Chanchua on 1/20/56 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Fade : NSObject

+ (Fade*) getObject;

- (void) loadData;
- (void) unloadData;
- (void) AssignDataToLayer: (CCLayer*) layer;

- (void) blackIt;
- (void) fadeOut;

@end
