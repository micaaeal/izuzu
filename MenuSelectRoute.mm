//
//  MenuSelectRoute.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import "MenuSelectRoute.h"
#import "Utils.h"

static float _s_routeButtonRadius   = 100;

@interface MenuSelectRoute()

@property (retain) NSMutableArray*      _routeButtonArray;
@property (retain) id<MenuSelectRoute>  _actionObject;
@property (assign) CGPoint              _anchor;

@end

@implementation MenuSelectRoute
@synthesize routeCount = _routeCount;
@synthesize _routeButtonArray;
@synthesize _actionObject;
@synthesize _anchor;

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _routeCount  = 0;
        _routeButtonArray   = [[NSMutableArray alloc] init];
        _actionObject       = nil;
        _anchor             = CGPointMake(0.0f, 0.0f);
    }
    return self;
}

- (void) dealloc
{
    [_routeButtonArray release];
    _routeButtonArray   = nil;
    
    [super dealloc];
}

- (void) loadButtonAtPoint: (CGPoint) point routeCount: (int) routeCount rootLayer: (CCLayer*) rootLayer
{
    _routeCount = routeCount;
    _anchor     = point;
    
    for (int i=0; i<_routeCount; ++i)
    {
        // @TODO critical optimize is needed here ... revision
        CCSprite* button = [CCSprite spriteWithFile: @"route_select_img.png"];
        button.position = point;
        [rootLayer addChild:button];
        
        CGFloat buttonScale = [UtilVec convertScaleIfRetina:button.scale];
        [button setScale:buttonScale];
        
        [_routeButtonArray addObject:button];
    }

}

- (void) setButtonAtPoint: (CGPoint) point
{
    CGPoint deltaPoint  = CGPointMake(point.x-_anchor.x, point.y-_anchor.y);
    
    for (int i=0; i<_routeButtonArray.count; ++i)
    {
        CCSprite* cButtonSprite = [_routeButtonArray objectAtIndex:i];
        CGPoint spritePosition  = cButtonSprite.position;
        cButtonSprite.position  = CGPointMake(spritePosition.x+deltaPoint.x, spritePosition.y+deltaPoint.y);
    }
    
    _anchor = point;
}

- (void) setRouteButtonDirectTo: (CGPoint) point buttonIndex: (int) buttonIndex
{
    if (buttonIndex>=_routeButtonArray.count || buttonIndex<0)
    {
        CCLOG(@"button index out of bound!!!");
        return;
    }
    
    float deltaX        = point.x - _anchor.x;
    float deltaY        = point.y - _anchor.y;
    CGFloat distance        = sqrtf( (deltaX*deltaX) + (deltaY*deltaY) );
    
    float deltaXAtRadius    = deltaX * _s_routeButtonRadius / distance;
    float deltaYAtRadius    = deltaY * _s_routeButtonRadius / distance;
    
    CCSprite* cButtonSprite = [_routeButtonArray objectAtIndex:buttonIndex];
    cButtonSprite.position  = CGPointMake(_anchor.x + deltaXAtRadius, 
                                          _anchor.y + deltaYAtRadius);
}

- (void) setActionObject: (id<MenuSelectRoute>) sender
{
    _actionObject   = sender;
}

- (void) checkActionByPoint: (CGPoint) point
{
    for (int i=0; i<_routeButtonArray.count; ++i)
    {
        CCSprite* cButtonSprite     = [_routeButtonArray objectAtIndex:i];
        CGRect cButtonSpriteRect    = cButtonSprite.boundingBox;
        
        if (point.x > cButtonSpriteRect.origin.x
            &&
            point.x <= cButtonSpriteRect.origin.x + cButtonSpriteRect.size.width )
        {
            if (point.y > cButtonSpriteRect.origin.y
                &&
                point.y <= cButtonSpriteRect.origin.y + cButtonSpriteRect.size.height )
            {
                [_actionObject onTouchButtonAtId:i];
            }
        }
    }
}

@end
