//
//  UtilVec.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/3/55 BE.
//
//

#import <Foundation/Foundation.h>

@interface UtilVec : NSObject

+ (CGPoint) convertVecIfRetina: (CGPoint) vec;
+ (CGFloat) convertScaleIfRetina: (CGFloat) scale;

+ (void) setGameScale: (CGFloat) gameScale;
+ (CGFloat) getGameScale;

@end
