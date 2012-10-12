//
//  Mission.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import "Mission.h"
#import "Event.h"
#import "Combo.h"

@interface Mission()

@property (assign) int                  _code;
@property (retain) NSMutableArray*      _events;
@property (assign) int                  _vertexStart;
@property (assign) int                  _vertexEnd;

@end

@implementation Mission
@synthesize _code;
@synthesize _events;
@synthesize _vertexStart;
@synthesize _vertexEnd;

#pragma mark - Global methods

static int _s_missionCode   = 0;
static NSMutableDictionary* _missionCacheDict   = nil;

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
        cMission._vertexStart   = 1; // config this line !
        cMission._vertexEnd     = 3; // config this line !
        
        NSMutableArray* eventArray  = [[NSMutableArray alloc] init];
        {
            Event* cEvent       = [[Event alloc] init];
            cEvent.atDistance   = 0.5; // config this line !
            
            NSMutableArray* comboArray  = [[NSMutableArray alloc] init];
            {
                Combo* cCombo   = [[Combo alloc] init];
                cCombo.startTime    = 1.0f;
                cCombo.endTime      = 1.5f;
                cCombo.value        = @"A";
                [comboArray addObject:cCombo];
                [cCombo release];
                cCombo  = nil;
            }
            {
                Combo* cCombo   = [[Combo alloc] init];
                cCombo.startTime    = 1.0f;
                cCombo.endTime      = 1.5f;
                cCombo.value        = @"B";
                [comboArray addObject:cCombo];
                [cCombo release];
                cCombo  = nil;
            }

            cEvent.comboArray   = comboArray;
            
            [comboArray release];
            comboArray  = nil;
            
            [eventArray addObject:cEvent];
            [cEvent release];
            cEvent  = nil;
        }
        {
            Event* cEvent       = [[Event alloc] init];
            cEvent.atDistance   = 0.7; // config this line !

            NSMutableArray* comboArray  = [[NSMutableArray alloc] init];
            {
                Combo* cCombo   = [[Combo alloc] init];
                cCombo.startTime    = 1.0f;
                cCombo.endTime      = 1.5f;
                cCombo.value        = @"C";
                [comboArray addObject:cCombo];
                [cCombo release];
                cCombo  = nil;
            }
            {
                Combo* cCombo   = [[Combo alloc] init];
                cCombo.startTime    = 1.0f;
                cCombo.endTime      = 1.5f;
                cCombo.value        = @"A";
                [comboArray addObject:cCombo];
                [cCombo release];
                cCombo  = nil;
            }
            {
                Combo* cCombo   = [[Combo alloc] init];
                cCombo.startTime    = 1.0f;
                cCombo.endTime      = 1.5f;
                cCombo.value        = @"B";
                [comboArray addObject:cCombo];
                [cCombo release];
                cCombo  = nil;
            }
            
            cEvent.comboArray   = comboArray;
            [comboArray release];
            comboArray  = nil;
            
            [eventArray addObject:cEvent];
            [cEvent release];
            cEvent  = nil;
        }
        cMission._events    = eventArray;
        [eventArray release];
        eventArray  = nil;
        
        [_missionCacheDict setObject:cMission forKey:missionCodeStr];
        
        [cMission release];
        cMission    = nil;
        
        return [_missionCacheDict objectForKey:missionCodeStr];
    }
    ++cMissionCode;
    
    return nil;
}

#pragma mark - Memory management methods

- (id) init
{
    self    = [super init];
    if (self)
    {
        _events         = [[NSMutableArray alloc] init];
        _vertexStart    = 0;
        _vertexEnd      = 0;
    }
    return self;
}

- (void) dealloc
{
    [_events release];
    _events = nil;
    
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

- (NSArray*) GetAllEvents
{
    return _events;
}

// distance is from 0.0 to 1.0
- (Event*) GetEventFromDistance: (float) distance
{
    int eventCount  = _events.count;
    
    Event* foundedEvent = nil;
    for ( int i=0; i<eventCount; ++i )
    {
        Event* cEvent   = [_events objectAtIndex:0];
        if ( distance > cEvent.atDistance )
        {
            foundedEvent    = cEvent;
        }
    }
    
    return foundedEvent; // if found return object, otherwise return nil
}

@end
