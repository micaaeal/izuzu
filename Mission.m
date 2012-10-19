//
//  Mission.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import "Mission.h"
#import "Combo.h"
#import "cocos2d.h"

@interface Mission()

@property (assign) int                  _code;
@property (assign) int                  _vertexStart;
@property (assign) int                  _vertexEnd;

@end

@implementation Mission
@synthesize _code;
@synthesize _vertexStart;
@synthesize _vertexEnd;

#pragma mark - Global methods

static int _s_missionCode   = 0;
static NSMutableDictionary* _s_missionCacheDict   = nil;

static CCSprite* _s_winFlag   = nil;
static CCSprite* _s_startSign = nil;

+ (void) loadData
{
    _s_winFlag    = [CCSprite spriteWithFile:@"win_flag.png"];
    _s_startSign  = [CCSprite spriteWithFile:@"start_sign.png"];
}

+ (void) unloadData
{
    // need to do something
}

+ (void) AssignDataToLayer: (CCLayer*) layer
{
    [layer addChild:_s_winFlag];
    [layer addChild:_s_startSign];
}

+ (void) setWinFlagPoint: (CGPoint) point
{
    [_s_winFlag setPosition:point];
}

+ (void) setStarSignPoint: (CGPoint) point
{
    [_s_startSign setPosition:point];
}

+ (void) setCurrentMissionCode: (int) missionCode
{
    _s_missionCode  = 0;
}

+ (int) getCurrentMissionCode
{
    return _s_missionCode;
}

+ (Mission*) GetMissionFromCode: (int) missionCode
{
    if ( ! _s_missionCacheDict )
    {
        _s_missionCacheDict   = [[NSMutableDictionary alloc] init];
    }
    
    // search by mission id
    int cMissionCode    = 0;
    if ( cMissionCode == missionCode )
    {
        // get mission from cache
        NSString* missionCodeStr    = [[NSString alloc] initWithFormat:@"%d", cMissionCode];
        Mission* missionFromCache   = [_s_missionCacheDict objectForKey:missionCodeStr];
        if ( missionFromCache )
        {
            return missionFromCache;
        }
        
        // create new mission
        Mission* cMission   = [[Mission alloc] init];
        cMission._code      = cMissionCode;
        cMission._vertexStart   = 21; // config this line !
        cMission._vertexEnd     = 23; // config this line !

        [_s_missionCacheDict setObject:cMission forKey:missionCodeStr];
        
        [cMission release];
        cMission    = nil;
        
        return [_s_missionCacheDict objectForKey:missionCodeStr];
    }
    ++cMissionCode;
    
    return nil;
}

+ (void) removeAllMissionCache
{
    [_s_missionCacheDict removeAllObjects];
    [_s_missionCacheDict release];
    _s_missionCacheDict = nil;
}

#pragma mark - Memory management methods

- (id) init
{
    self    = [super init];
    if (self)
    {
        _vertexStart    = 0;
        _vertexEnd      = 0;
    }
    return self;
}

- (void) dealloc
{
    
    [super dealloc];
}

#pragma mark - Class methods

- (int) GetStartVertex
{
    return _vertexStart;
}

- (int) GetEndVertex
{
    return _vertexEnd;
}

@end
