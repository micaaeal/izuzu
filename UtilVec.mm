//
//  UtilVec.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/3/55 BE.
//
//

#import "UtilVec.h"
#import "cocos2d.h"

static CGFloat  _s_gameScale    = 1.0f;

@implementation UtilVec

// screen convertion
+ (CGPoint) convertVecIfRetina: (CGPoint&) vec
{
    return vec;
}

+ (CGFloat) convertScaleIfRetina: (CGFloat) scale
{
    CGFloat screenScale     = [[UIScreen mainScreen] scale];
    CGFloat netScale        = scale * screenScale;
    return netScale;
}

// game scale
+ (void) setGameScale: (CGFloat) gameScale
{
    _s_gameScale    = gameScale;
}

+ (CGFloat) getGameScale
{
    return _s_gameScale;
}

@end
