//
//  Fuel.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/19/55 BE.
//
//

#import "Console.h"
#import "UtilVec.h"

static Console*    _s_console = nil;

@interface Console()

@property (retain) CCSprite*    _spriteFuel;
@property (assign) float        _fuelNorm;
@property (retain) CCSprite*    _accelSprite;
@property (retain) CCSprite*    _breakSprite;

@property (assign) BOOL         _isTouchingAccel;
@property (assign) BOOL         _isTouchingBreak;

@property (assign) BOOL         _isTouchedAccel;
@property (assign) BOOL         _isTouchedBreak;

@end

@implementation Console
@synthesize _spriteFuel;
@synthesize _fuelNorm;
@synthesize _accelSprite;
@synthesize _breakSprite;
@synthesize _isTouchingAccel;
@synthesize _isTouchingBreak;
@synthesize _isTouchedAccel;
@synthesize _isTouchedBreak;

+ (Console*) getObject
{
    if ( ! _s_console )
    {
        _s_console = [[Console alloc] init];
    }
    return _s_console;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        _spriteFuel     = nil;
        _fuelNorm       = 1.0f;
        
        _accelSprite    = nil;
        _breakSprite    = nil;
        
        _isTouchingAccel    = NO;
        _isTouchingBreak    = NO;
        
        _isTouchedAccel     = NO;
        _isTouchedBreak     = NO;
    }
    return self;
}

- (void) LoadData
{
    _spriteFuel     = [CCSprite spriteWithFile:@"fuel_gauge.png"];
    
    _accelSprite    = [CCSprite spriteWithFile:@"accel_padel.png"];
    _breakSprite    = [CCSprite spriteWithFile:@"break_padel.png"];
}

- (void) UnloadData
{
    // need doing something
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    [layer addChild:_spriteFuel];

    // win size
    CGSize winSize          = [CCDirector sharedDirector].winSize;
    
    // meter
    CGPoint fuelGaugePoint  = CGPointMake(winSize.width - 40,
                                          winSize.height - 40);
    
    [_spriteFuel setPosition:fuelGaugePoint];
    [_spriteFuel setScale:[UtilVec convertScaleIfRetina:_spriteFuel.scale]];
    
    // padel
    CGFloat accelPadelX     = winSize.width - 40.0f;
    CGFloat accelPadelY     = 100.0f;
    CGFloat breakPadelX     = winSize.width - 120.0f;
    CGFloat breakPadelY     = 65.0f;
    
    if ( _accelSprite )
    {
        [layer addChild:_accelSprite];      
        [_accelSprite setPosition:CGPointMake(accelPadelX, accelPadelY)];
        [_accelSprite setScale:[UtilVec convertScaleIfRetina:_accelSprite.scale]];
    }
    
    if ( _breakSprite )
    {
        [layer addChild:_breakSprite];        
        [_breakSprite setPosition:CGPointMake(breakPadelX, breakPadelY)];
        [_breakSprite setScale:[UtilVec convertScaleIfRetina:_breakSprite.scale]];
    }
}

- (void) Update: (float) deltaTime
{
    // update fuel
    if ( _spriteFuel )
    {
        if ( _fuelNorm >= 0.75 )
        {
            ccColor3B color = {0, 255, 0};
            [_spriteFuel setColor:color];
        }
        else if ( _fuelNorm >= 0.5 )
        {
            ccColor3B color = {255, 252, 10};
            [_spriteFuel setColor:color];
        }
        else if ( _fuelNorm >= 0.25 )
        {
            ccColor3B color = {255, 131, 10};
            [_spriteFuel setColor:color];
        }
        else
        {
            ccColor3B color = {255, 50, 10};
            [_spriteFuel setColor:color];
        }
    }
    
    // update accel
    if ( _isTouchingAccel && !_isTouchedAccel )
    {
    }
    if ( !_isTouchingAccel && _isTouchedAccel )
    {
    }
    
    // update break
    if ( _isTouchingBreak && !_isTouchedBreak )
    {
    }
    if ( !_isTouchingBreak && _isTouchedBreak )
    {
    }
    
    _isTouchedAccel = _isTouchingAccel;
    _isTouchedBreak = _isTouchingBreak;
}

- (void) SetFuelNorm: (float) fuelNorm // between 0.0 and 1.0
{
    _fuelNorm   = fuelNorm;
}

- (float) GetFuelNorm // between 0.0 and 1.0
{
    return _fuelNorm;
}

- (void) touchButtonAtPoint: (CGPoint) point
{
    // accel padel
    {
        float width     = _accelSprite.contentSize.width * _accelSprite.scaleX;
        float height    = _accelSprite.contentSize.height * _accelSprite.scaleY;
        float x         = _accelSprite.position.x;
        float y         = _accelSprite.position.y;

        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            _isTouchingAccel    = YES;
        }
        else 
        {
            _isTouchingAccel    = NO;
        }
    }
    
    // break padel
    {
        float width     = _breakSprite.contentSize.width * _breakSprite.scaleX;
        float height    = _breakSprite.contentSize.height * _breakSprite.scaleY;
        float x         = _breakSprite.position.x;
        float y         = _breakSprite.position.y;
        
        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            _isTouchingBreak    = YES;
        }
        else 
        {
            _isTouchingBreak    = NO;
        }
    }
}

- (void) touchMoveAtPoint: (CGPoint) point
{
    // accel padel
    {
        float width     = _accelSprite.contentSize.width * _accelSprite.scaleX;
        float height    = _accelSprite.contentSize.height * _accelSprite.scaleY;
        float x         = _accelSprite.position.x;
        float y         = _accelSprite.position.y;
        
        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            // do nothing
        }
        else 
        {
            _isTouchingAccel    = NO;
        }
    }
    
    // break padel
    {
        float width     = _breakSprite.contentSize.width * _breakSprite.scaleX;
        float height    = _breakSprite.contentSize.height * _breakSprite.scaleY;
        float x         = _breakSprite.position.x;
        float y         = _breakSprite.position.y;
        
        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            // do nothing
        }
        else 
        {
            _isTouchingBreak    = NO;
        }
    }
}

- (void) unTouchButtonAtPoint: (CGPoint) point
{
    // accel padel
    {
        float width     = _accelSprite.contentSize.width * _accelSprite.scaleX;
        float height    = _accelSprite.contentSize.height * _accelSprite.scaleY;
        float x         = _accelSprite.position.x;
        float y         = _accelSprite.position.y;
        
        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            _isTouchingAccel    = NO;
        }
        else 
        {
            // do nothing
        }
    }
    
    // break padel
    {
        float width     = _breakSprite.contentSize.width * _breakSprite.scaleX;
        float height    = _breakSprite.contentSize.height * _breakSprite.scaleY;
        float x         = _breakSprite.position.x;
        float y         = _breakSprite.position.y;
        
        BOOL isTouchOnTarget    = NO;
        if ( point.x >= x - width*0.5f && point.x <= x + width*0.5f )
        {
            if ( point.y >= y - height*0.5f && point.y <= y + height*0.5f )
            {
                isTouchOnTarget = YES;
            }
        }
        
        if ( isTouchOnTarget )
        {
            _isTouchingBreak    = NO;
        }
        else 
        {
            // do nothing
        }
    }
}

- (BOOL) getIsTouchingAccel
{
    return _isTouchingAccel;
}

- (BOOL) getIsTouchingBreak
{
    return _isTouchingBreak;
}

- (void) hideConsole
{
    [_spriteFuel setOpacity:0];
    [_accelSprite setOpacity:0];
    [_breakSprite setOpacity:0];
}

- (void) showConsole
{
    [_spriteFuel setOpacity:255];
    [_accelSprite setOpacity:255];
    [_breakSprite setOpacity:255];    
}

@end
