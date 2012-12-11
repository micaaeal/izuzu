//
//  WindShield.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/8/55 BE.
//
//

#import "WindShield.h"
#import "cocos2d.h"
#import "UtilVec.h"

WindShield* _s_object   = nil;

@interface WindShield()

@property (assign) BOOL         _hasAnythingOnWindshield;

@property (retain) CCSprite*    _waterSprite;
@property (assign) BOOL         _isShowingWater;

- (void) _checkHasAnythingOnWindshield;

@end

@implementation WindShield
@synthesize _waterSprite;
@synthesize _hasAnythingOnWindshield;
@synthesize _isShowingWater;

+ (WindShield*) getObject
{
    if ( ! _s_object )
    {
        _s_object = [[WindShield alloc] init];
    }
    
    return _s_object;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        _waterSprite                = nil;
        _hasAnythingOnWindshield    = NO;
        _isShowingWater             = NO;
    }
    return self;
}

- (void) dealloc
{
    
    [super dealloc];
}

- (void) onStart
{
    
}

- (void) onFinish
{
    
}

- (void) assignDataToLayer: (CCLayer*) layer
{
    CGSize winSize          = [CCDirector sharedDirector].winSize;
    
    CCSprite* cSprite   = [CCSprite spriteWithFile:@"water_windshield.png"];
    [layer addChild:cSprite];
    [cSprite setPosition:CGPointMake(winSize.width * 0.5f,
                                     winSize.height * 0.5f)];
    [cSprite setScale:0.5f];
    [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
    [cSprite setOpacity:0];
    _waterSprite    = cSprite;
}

- (void) onUpdate: (float) deltaTime
{
    
}

// wind shield objects
- (BOOL) hasAnythingOnWindshield
{
    return self._hasAnythingOnWindshield;
}

- (void) clearAllVisionBarrier
{
    [self clearWater];
}

- (void) showWater
{
    [_waterSprite setOpacity:255];
    self._isShowingWater            = YES;
    self._hasAnythingOnWindshield   = YES;
}

- (BOOL) getIsShowingWater
{
    return self._isShowingWater;
}

- (void) clearWater
{
    [_waterSprite setOpacity:0];
    self._isShowingWater    = NO;
    [self _checkHasAnythingOnWindshield];
}

#pragma mark - PIMPL

- (void) _checkHasAnythingOnWindshield
{
    BOOL flag   = NO;
    
    if (self._isShowingWater)
    {
        flag    = YES;
    }
    
    self._hasAnythingOnWindshield   = flag;
}

@end
