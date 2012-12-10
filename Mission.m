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

// --------------------------------------------------------
@interface MissionProfile : NSObject
@property (assign) int  startVertexCode;
@property (assign) int  endVertexCode;
@end

@implementation MissionProfile
@end

// --------------------------------------------------------
static Mission* _s_mission  = nil;

@interface Mission()

@property (assign) int _currentMissionCode;
@property (retain) NSMutableArray* _missionArray;

@property (retain) CCSprite*    _winFlag;
@property (retain) CCSprite*    _startSign;

@end

@implementation Mission
@synthesize _currentMissionCode;
@synthesize _missionArray;

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

#pragma mark - Memory management methods

- (id) init
{
    self    = [super init];
    if (self)
    {
        _missionArray   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_missionArray release];
    _missionArray   = nil;
    
    [super dealloc];
}

- (void) loadData
{
    // image
    _winFlag    = [CCSprite spriteWithFile:@"win_flag.png"];
    _startSign  = [CCSprite spriteWithFile:@"start_sign.png"];
    
    [_winFlag retain];
    [_startSign retain];
    
    // mission data
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 21;
        cMissionProfile.endVertexCode   = 23;
        [_missionArray addObject:cMissionProfile];
        [cMissionProfile release];
        cMissionProfile = nil;
    }
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 1;
        cMissionProfile.endVertexCode   = 10;
        [_missionArray addObject:cMissionProfile];
        [cMissionProfile release];
        cMissionProfile = nil;
    }
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 10;
        cMissionProfile.endVertexCode   = 20;
        [_missionArray addObject:cMissionProfile];
        [cMissionProfile release];
        cMissionProfile = nil;
    }
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 30;
        cMissionProfile.endVertexCode   = 0;
        [_missionArray addObject:cMissionProfile];
        [cMissionProfile release];
        cMissionProfile = nil;
    }
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 2;
        cMissionProfile.endVertexCode   = 15;
        [_missionArray addObject:cMissionProfile];
        [cMissionProfile release];
        cMissionProfile = nil;
    }
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
    _currentMissionCode  = missionCode;
}

- (int) getCurrentMissionCode
{
    return _currentMissionCode;
}

- (int) getMissionCount
{
    return _missionArray.count;
}

- (int) GetStartVertexFromMissionCode: (int) missionCode
{
    MissionProfile* cMissionProfile = [_missionArray objectAtIndex:missionCode];
    return cMissionProfile.startVertexCode;
}

- (int) GetEndVertexFromMissionCode: (int) missionCode
{
    MissionProfile* cMissionProfile = [_missionArray objectAtIndex:missionCode];
    return cMissionProfile.endVertexCode;
}

@end
