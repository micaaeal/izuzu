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
@property (retain) NSMutableArray*      _routeButtonArrayRed;
@property (retain) CCLayer*             _rootLayer;

@end

@implementation MenuSelectRoute
@synthesize routeCount = _routeCount;
@synthesize _routeButtonArray;
@synthesize _actionObject;
@synthesize _anchor;
@synthesize _routeButtonArrayRed;
@synthesize _rootLayer;

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _routeCount  = 0;
        _routeButtonArray   = [[NSMutableArray alloc] init];
        _actionObject       = nil;
        _anchor             = CGPointMake(0.0f, 0.0f);
        _routeButtonArrayRed    = [[NSMutableArray alloc] init];
        _rootLayer          = nil;
    }
    return self;
}

- (void) dealloc
{
    for ( CCSprite* cButton in _routeButtonArrayRed )
    {
        [_rootLayer removeChild:cButton cleanup:YES];
    }
    
    [_routeButtonArrayRed release];
    _routeButtonArrayRed    = nil;
    
    for ( CCSprite* cButton in _routeButtonArray )
    {
        [_rootLayer removeChild:cButton cleanup:YES];
    }
    
    [_routeButtonArray release];
    _routeButtonArray   = nil;
    
    [super dealloc];
}

- (void) loadButtonAtPoint: (CGPoint) point routeCount: (int) routeCount rootLayer: (CCLayer*) rootLayer
{
    _routeCount = routeCount;
    _anchor     = point;
    _rootLayer  = rootLayer;
    
    for (int i=0; i<_routeCount; ++i)
    {
        // load select buttons
        {
            CCSprite* button = [CCSprite spriteWithFile: @"route_select_img.png"];
            button.position = point;
            [rootLayer addChild:button];
            
            CGFloat buttonScale = [UtilVec convertScaleIfRetina:button.scale];
            [button setScale:buttonScale];
            
            [_routeButtonArray addObject:button];
        }
        
        // load desselect buttons
        {
            CCSprite* button    = [CCSprite spriteWithFile: @"route_disselect_img.png"];
            button.position     = point;
            [rootLayer addChild:button];
            
            CGFloat buttonScale = [UtilVec convertScaleIfRetina:button.scale];
            [button setScale:buttonScale];
            
            [_routeButtonArrayRed addObject:button];
        }
    }

}

- (void) setButtonAtPoint: (CGPoint) point
{
    CGPoint deltaPoint  = CGPointMake(point.x-_anchor.x,
                                      point.y-_anchor.y);
    
    for (int i=0; i<_routeButtonArray.count; ++i)
    {
        // for green buttons
        {
            CCSprite* cButtonSprite = [_routeButtonArray objectAtIndex:i];
            CGPoint spritePosition  = cButtonSprite.position;
            cButtonSprite.position  = CGPointMake(spritePosition.x+deltaPoint.x,
                                                  spritePosition.y+deltaPoint.y);
        }
        // for red buttons
        {
            CCSprite* cButtonSprite = [_routeButtonArrayRed objectAtIndex:i];
            CGPoint spritePosition  = cButtonSprite.position;
            cButtonSprite.position  = CGPointMake(spritePosition.x+deltaPoint.x,
                                                  spritePosition.y+deltaPoint.y);
        }
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
    
    // for green butttons
    {
        CCSprite* cButtonSprite = [_routeButtonArray objectAtIndex:buttonIndex];
        cButtonSprite.position  = CGPointMake(_anchor.x + deltaXAtRadius,
                                              _anchor.y + deltaYAtRadius);
    }
    // for red butttons
    {
        CCSprite* cButtonSprite = [_routeButtonArrayRed objectAtIndex:buttonIndex];
        cButtonSprite.position  = CGPointMake(_anchor.x + deltaXAtRadius,
                                              _anchor.y + deltaYAtRadius);
    }
    
    // init state
    [self setButtonStateToGreen:buttonIndex];
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
                BOOL isGreen    = [self isThisButtonGreen:i];
                [_actionObject onTouchButtonAtId:i isGreen:isGreen];
            }
        }
    }
}

- (void) setButtonStateToRed: (int) buttonIndex
{
    CCSprite* redButton     = [_routeButtonArrayRed objectAtIndex:buttonIndex];
    CCSprite* greenButton   = [_routeButtonArray objectAtIndex:buttonIndex];
    
    [greenButton setOpacity:0];
    [redButton setOpacity:255];
}

- (void) setButtonStateToGreen: (int) buttonIndex
{
    CCSprite* redButton     = [_routeButtonArrayRed objectAtIndex:buttonIndex];
    CCSprite* greenButton   = [_routeButtonArray objectAtIndex:buttonIndex];

    [greenButton setOpacity:255];
    [redButton setOpacity:0];
}

- (void) hideButtonAtIndex: (int) buttonIndex
{
    CCSprite* redButton     = [_routeButtonArrayRed objectAtIndex:buttonIndex];
    CCSprite* greenButton   = [_routeButtonArray objectAtIndex:buttonIndex];
    
    [greenButton setOpacity:0];
    [redButton setOpacity:0];
}

- (void) showButtonAtIndex: (int) buttonIndex
{
    CCSprite* redButton     = [_routeButtonArrayRed objectAtIndex:buttonIndex];
    CCSprite* greenButton   = [_routeButtonArray objectAtIndex:buttonIndex];
    
    [greenButton setOpacity:255];
    [redButton setOpacity:255];
}

- (BOOL) isThisButtonGreen: (int) buttonIndex
{
    CCSprite* greenButton   = [_routeButtonArray objectAtIndex:buttonIndex];
    
    if ( greenButton.opacity )
        return YES;
    return NO;
}

- (BOOL) isThisButtonRed: (int) buttonIndex
{
    CCSprite* redButton     = [_routeButtonArrayRed objectAtIndex:buttonIndex];
    
    if ( redButton.opacity )
        return YES;
    return NO;
}

@end
