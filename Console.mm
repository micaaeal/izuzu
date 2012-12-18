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
@property (retain) CCSprite*    _spriteFuelGaugeNeedle;
@property (assign) float        _fuelNorm;
@property (assign) float        _speedNorm;
@property (retain) CCLabelTTF*  _txtSpeed;
@property (retain) CCSprite*    _spriteSpeedMeter;

@property (retain) CCSprite*    _accelSprite;
@property (retain) CCSprite*    _breakSprite;

@property (assign) BOOL         _isTouchingAccel;
@property (assign) BOOL         _isTouchingBreak;

@property (assign) BOOL         _isTouchedAccel;
@property (assign) BOOL         _isTouchedBreak;

@property (assign) BOOL         _hasAddResourcesToLayer;
@end

@implementation Console
@synthesize _spriteFuel;
@synthesize _spriteFuelGaugeNeedle;
@synthesize _fuelNorm;
@synthesize _speedNorm;
@synthesize _txtSpeed;
@synthesize _spriteSpeedMeter;
@synthesize _accelSprite;
@synthesize _breakSprite;
@synthesize _isTouchingAccel;
@synthesize _isTouchingBreak;
@synthesize _isTouchedAccel;
@synthesize _isTouchedBreak;
@synthesize _hasAddResourcesToLayer;

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
        _spriteFuelGaugeNeedle  = nil;
        _fuelNorm       = 1.0f;
        _speedNorm      = 0.0f;
        
        _txtSpeed       = (CCLabelTTF*)[CCLabelTTF labelWithString:@"0"
                                                        dimensions:CGSizeMake(120, 50)
                                                        hAlignment:kCCTextAlignmentRight
                                                          fontName:@"Arial"
                                                          fontSize:16];
        [_txtSpeed retain];
        
        _accelSprite    = nil;
        _breakSprite    = nil;
        
        _isTouchingAccel    = NO;
        _isTouchingBreak    = NO;
        
        _isTouchedAccel     = NO;
        _isTouchedBreak     = NO;
        
        _hasAddResourcesToLayer = NO;
    }
    return self;
}

- (void) LoadData
{
    _spriteFuel     = [CCSprite spriteWithFile:@"fuel_gauge.png"];
    _spriteFuelGaugeNeedle  = [CCSprite spriteWithFile:@"fuel_gauge_needle.png"];
    
    _accelSprite    = [CCSprite spriteWithFile:@"AcceleratorButton.png"];
    _breakSprite    = [CCSprite spriteWithFile:@"breakButton.png"];
    
    _spriteSpeedMeter   = [CCSprite spriteWithFile:@"speed_meter.png"];
    
    [_spriteFuel retain];
    [_spriteFuelGaugeNeedle retain];
    [_accelSprite retain];
    [_breakSprite retain];
    [_spriteSpeedMeter retain];
}

- (void) UnloadData
{
    // need doing something
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    if ( ! _hasAddResourcesToLayer )
    {
        [layer addChild:_spriteFuel];
        [layer addChild:_spriteFuelGaugeNeedle];
    }
    
    // win size
    CGSize winSize          = [CCDirector sharedDirector].winSize;
    
    // meter
    CGPoint fuelGaugePoint  = CGPointMake(winSize.width - 65,
                                          winSize.height - 65);
    
    [_spriteFuel setPosition:fuelGaugePoint];
    [_spriteFuel setScale:0.5f];
    [_spriteFuel setScale:[UtilVec convertScaleIfRetina:_spriteFuel.scale]];

    [_spriteFuelGaugeNeedle setAnchorPoint:CGPointMake(0.5f,
                                                       0.1f)];

    [_spriteFuelGaugeNeedle setPosition:CGPointMake(fuelGaugePoint.x - 0.2,
                                                    fuelGaugePoint.y + 2.0f )];
    [_spriteFuelGaugeNeedle setScale:0.5f];
    [_spriteFuelGaugeNeedle setScale:[UtilVec convertScaleIfRetina:_spriteFuelGaugeNeedle.scale]];

    // text speed
    if ( ! _hasAddResourcesToLayer )
    {
        [layer addChild:_spriteSpeedMeter];
        [layer addChild:_txtSpeed];
    }
    [_spriteSpeedMeter setPosition:CGPointMake(61.0f, winSize.height - 90)];
    [_spriteSpeedMeter setScale:[UtilVec convertScaleIfRetina:_spriteSpeedMeter.scale]];
    [_txtSpeed setPosition:CGPointMake(-20.0f, winSize.height - 118)];
    [_txtSpeed setScale:[UtilVec convertScaleIfRetina:_txtSpeed.scale]];
    
    // padel
    CGFloat accelPadelX     = winSize.width - 40.0f;
    CGFloat accelPadelY     = 50.0f;
    CGFloat breakPadelX     = winSize.width - 120.0f;
    CGFloat breakPadelY     = 40.0f;
    
    if ( _accelSprite )
    {
        if ( ! _hasAddResourcesToLayer )
        {
            [layer addChild:_accelSprite];
        }
        [_accelSprite setScale:0.5f];
        [_accelSprite setPosition:CGPointMake(accelPadelX, accelPadelY)];
        [_accelSprite setScale:[UtilVec convertScaleIfRetina:_accelSprite.scale]];
    }
    
    if ( _breakSprite )
    {
        if ( ! _hasAddResourcesToLayer )
        {
            [layer addChild:_breakSprite];
        }
        [_breakSprite setScale:0.5f];
        [_breakSprite setPosition:CGPointMake(breakPadelX, breakPadelY)];
        [_breakSprite setScale:[UtilVec convertScaleIfRetina:_breakSprite.scale]];
    }
    
    _hasAddResourcesToLayer = YES;
}

- (void) Update: (float) deltaTime
{
    // update fuel
    if ( _spriteFuel && _spriteFuelGaugeNeedle )
    {
        //float angleMax      = 90;
        //float angleMin      = -180;
        float angleMax      = -180;
        float angleMin      = 90;
        float angleDelta    = angleMax - angleMin;
        
        float angle         = (angleDelta * _fuelNorm) + angleMin;
        float needleAngle   = angle;
        
        [_spriteFuelGaugeNeedle setRotation:needleAngle];
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
    if ( fuelNorm < 0.0f )
        fuelNorm   = 0.0f;
    else if ( fuelNorm > 1.0f )
        fuelNorm   = 1.0f;
    
    _fuelNorm   = fuelNorm;
}

- (float) GetFuelNorm // between 0.0 and 1.0
{
    return _fuelNorm;
}

- (void) SetSpeedNorm: (float) speedNorm // between 0.0 and 1.0
{
    if ( speedNorm < 0.0f )
        speedNorm   = 0.0f;
    else if ( speedNorm > 1.0f )
        speedNorm   = 1.0f;
    
    _speedNorm  = speedNorm;
    
    // set speed to text
    float carSpeedMax   = 130.0f;
    float carSpeedMin   = 0.0f;
    float carSpeedDelta = carSpeedMax - carSpeedMin;
    
    float cCarSpeed     = ( carSpeedDelta * _speedNorm ) + carSpeedMin;
    int cCarSpeedInt    = cCarSpeed;
    
    NSString* speedStr  = [NSString stringWithFormat:@"%d", cCarSpeedInt];
    
    [_txtSpeed setString:speedStr];
}

- (float) GetSpeedNorm // between 0.0 and 1.0
{
    return _speedNorm;
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
    [_spriteFuelGaugeNeedle setOpacity:0];
    [_accelSprite setOpacity:0];
    [_breakSprite setOpacity:0];
    [_spriteSpeedMeter setOpacity:0];
    [_txtSpeed setOpacity:0];
}

- (void) showConsole
{
    [_spriteFuel setOpacity:255];
    [_spriteFuelGaugeNeedle setOpacity:255];
    [_accelSprite setOpacity:255];
    [_breakSprite setOpacity:255];
    [_spriteSpeedMeter setOpacity:255];
    [_txtSpeed setOpacity:255];
}

@end
