//
//  Mission.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import "Mission.h"
#import "Event.h"
#import "cocos2d.h"

static Mission* _s_mission  = nil;

@interface Mission()

@property (assign) int  _code;
@property (assign) int  _vertexStart;
@property (assign) int  _vertexEnd;

@property (assign) int  _missionCode;
@property (retain) NSMutableDictionary* _missionCacheDict;

@property (retain) CCSprite*    _winFlag;
@property (retain) CCSprite*    _startSign;

@end

@implementation Mission
@synthesize _code;
@synthesize _vertexStart;
@synthesize _vertexEnd;

@synthesize _missionCode;
@synthesize _missionCacheDict;

@synthesize _winFlag;
@synthesize _startSign;

#pragma mark - Global methods

+ (Mission*) getObject
{
    if ( ! _s_mission )
    {
        _s_mission = [[Mission alloc] init];
    }
    
    return _s_mission;
}

- (void) loadData
{
    _winFlag    = [CCSprite spriteWithFile:@"win_flag.png"];
    _startSign  = [CCSprite spriteWithFile:@"start_sign.png"];
    
    [_winFlag retain];
    [_startSign retain];
}

- (void) unloadData
{
    // need to do something
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    [layer addChild:_winFlag];
    [layer addChild:_startSign];
}

- (void) setWinFlagPoint: (CGPoint) point
{
    [_winFlag setPosition:point];
}

- (void) setStarSignPoint: (CGPoint) point
{
    [_startSign setPosition:point];
}

- (void) setCurrentMissionCode: (int) missionCode
{
    _missionCode  = 0;
}

- (int) getCurrentMissionCode
{
    return _missionCode;
}

- (Mission*) GetMissionFromCode: (int) missionCode
{
    if ( ! _missionCacheDict )
    {
        _missionCacheDict   = [[NSMutableDictionary alloc] init];
    }
    
    // search by mission id
    int cMissionCode    = 0;
    if ( cMissionCode == missionCode )
    {
        // get mission from cache
        NSString* missionCodeStr    = [[NSString alloc] initWithFormat:@"%d", cMissionCode];
        Mission* missionFromCache   = [_missionCacheDict objectForKey:missionCodeStr];
        if ( missionFromCache )
        {
            return missionFromCache;
        }
        
        // create new mission
        Mission* cMission   = [[Mission alloc] init];
        cMission._code      = cMissionCode;
        cMission._vertexStart   = 21; // config this line !
        cMission._vertexEnd     = 23; // config this line !

        [_missionCacheDict setObject:cMission forKey:missionCodeStr];
        
        [cMission release];
        cMission    = nil;
        
        return [_missionCacheDict objectForKey:missionCodeStr];
    }
    ++cMissionCode;
    
    return nil;
}

- (void) removeAllMissionCache
{
    [_missionCacheDict removeAllObjects];
    [_missionCacheDict release];
    _missionCacheDict = nil;
}

- (int) GetStartVertex
{
    return _vertexStart;
}

- (int) GetEndVertex
{
    return _vertexEnd;
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

@end
