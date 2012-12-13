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
#import "Car.h"
#import "Order.h"
#import "UtilVec.h"

// --------------------------------------------------------
@interface MissionProfile : NSObject
@property (assign) int  startVertexCode;
@property (assign) int  endVertexCode;
@property (retain) Order*   order;
@property (assign) double   missionTime;
@end

@implementation MissionProfile
- (id)init
{
    self    = [super init];
    if ( self )
    {
        _startVertexCode    = 0;
        _endVertexCode      = 0;
        _order              = 0;
        _missionTime        = 0.0;
    }
    return self;
}
@end

// --------------------------------------------------------
static Mission* _s_mission  = nil;

@interface Mission()

@property (assign) int _currentMissionCode;
@property (retain) NSMutableArray* _missionArray;

@property (retain) CCSprite*    _winFlag;
@property (retain) CCSprite*    _startSign;

@property (retain) CCSprite*    _orderBox;
@property (retain) NSMutableArray*  _orderSpriteArray;

@property (retain) CCLayer*     _currentLayer;

@end

@implementation Mission
@synthesize _currentMissionCode;
@synthesize _missionArray;

@synthesize _winFlag;
@synthesize _startSign;

@synthesize _orderBox;
@synthesize _orderSpriteArray;

@synthesize _currentLayer;

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
        _missionArray       = [[NSMutableArray alloc] init];
        _orderSpriteArray   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_orderSpriteArray release];
    _orderSpriteArray   = nil;
    [_missionArray release];
    _missionArray   = nil;
    
    [super dealloc];
}

- (void) loadData
{
    // image
    _winFlag    = [CCSprite spriteWithFile:@"win_flag.png"];
    _startSign  = [CCSprite spriteWithFile:@"start_sign.png"];
    _orderBox   = [CCSprite spriteWithFile:@"box.png"];
    
    [_winFlag retain];
    [_startSign retain];
    [_orderBox retain];
    
    // mission data
    {
        MissionProfile* cMissionProfile = [[MissionProfile alloc] init];
        cMissionProfile.startVertexCode = 21;
        cMissionProfile.endVertexCode   = 23;
        [_missionArray addObject:cMissionProfile];
        Order* cOrder   = [[Order alloc] init];
        [cOrder addOrderAtPosition:CGPointMake(5570.991211,-4197.246094)];
        [cOrder addOrderAtPosition:CGPointMake(6386.780762,-3797.246094)];
        [cOrder addOrderAtPosition:CGPointMake(7086.780762,-4255.140625)];
        cMissionProfile.order   = cOrder;
        [cOrder release];
        cOrder  = nil;
        cMissionProfile.missionTime = 10.0;
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
    _currentLayer   = layer;
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

- (Order*) GetORderFromMissionCode: (int) missionCode
{
    MissionProfile* cMissionProfile = [_missionArray objectAtIndex:missionCode];
    return cMissionProfile.order;
}

- (double) GetMissionTimeFromMissionCode: (int) missionCode
{
    MissionProfile* cMissionProfile = [_missionArray objectAtIndex:missionCode];
    return cMissionProfile.missionTime;
}

- (void) SetMapLayer: (CCLayer*) mapLayer
{
    _currentLayer   = mapLayer;
}

- (void) AddBoxSpriteToMapLayerAtPosition: (CGPoint) position
{
    CCSprite* orderBoxSprite    = [CCSprite spriteWithFile:@"box.png"];
    [_orderSpriteArray addObject:orderBoxSprite];
    [_currentLayer addChild:orderBoxSprite];
    [orderBoxSprite setPosition:position];
    [orderBoxSprite setScale:[UtilVec convertScaleIfRetina:orderBoxSprite.scale]];
}

- (void) ClearAllBoxSpritesFromMapLayer
{
    for ( int i=0; i<_orderSpriteArray.count; ++i )
    {
        CCSprite* cSprite   = [_orderSpriteArray objectAtIndex:i];
        [_currentLayer removeChild:cSprite cleanup:YES];
    }
}

- (void) HideBoxSpriteFromMapLayerByPosition: (CGPoint) position
{
    
}

- (void) Update: (float) dt
{
    CGRect carRect   = [Car getBoundingBox];
    float carTop       = carRect.origin.y + carRect.size.height;
    float carBottom    = carRect.origin.y;
    float carLeft      = carRect.origin.x;
    float carRight     = carRect.origin.x + carRect.size.width;
    
    for (CCSprite* cSprite in _orderSpriteArray)
    {
        CGRect cEventRect   = cSprite.boundingBox;
        CGPoint eventPoints[4];
        
        eventPoints[0]      = CGPointMake(cEventRect.origin.x,
                                          cEventRect.origin.y
                                          );
        eventPoints[1]      = CGPointMake(cEventRect.origin.x,
                                          cEventRect.origin.y + cEventRect.size.height
                                          );
        eventPoints[2]      = CGPointMake(cEventRect.origin.x + cEventRect.size.width,
                                          cEventRect.origin.y
                                          );
        eventPoints[3]      = CGPointMake(cEventRect.origin.x + cEventRect.size.width,
                                          cEventRect.origin.y + cEventRect.size.height
                                          );
        
        // check event touching
        BOOL isThisBoxTouchTheCar = NO;
        for (int i=0; i<4; ++i)
        {
            CGPoint& cEventPoint    = eventPoints[i];
            if ( cEventPoint.x >= carLeft && cEventPoint.x <= carRight )
            {
                if ( cEventPoint.y >= carBottom && cEventPoint.y <= carTop )
                {
                    isThisBoxTouchTheCar  = YES;
                    break;
                }
            }
        }
        
        if ( isThisBoxTouchTheCar )
        {
            if ( cSprite.opacity != 0 )
            {
                if ( _delegate )
                {
                    int totalOrder  = [self getCurrentTotalOrder];
                    
                    int gotCount    = [self getCurrentGotOrder];
                    [cSprite setOpacity:0];
                    
                    [_delegate onGettingOrder:self totalOrder:totalOrder gottOrder:gotCount];
                }
                [cSprite setOpacity:0];
            }
        }
    }
}

- (int) getCurrentTotalOrder
{
    int totalOrder  = _orderSpriteArray.count;
    return totalOrder;
}
- (int) getCurrentGotOrder
{
    int gotCount    = 0;
    for (int i=0; i<_orderSpriteArray.count; ++i)
    {
        CCSprite* cOrderSprite  = [_orderSpriteArray objectAtIndex:i];
        if ( cOrderSprite.opacity == 0 )
        {
            ++gotCount;
        }
    }
    return gotCount;
}

@end
