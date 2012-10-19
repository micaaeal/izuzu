//
//  Fuel.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/19/55 BE.
//
//

#import "Fuel.h"
#import "UtilVec.h"

static Fuel*    _s_fuel = nil;

@interface Fuel()

@property (retain) CCSprite*    _sprite;
@property (assign) float        _fuelNorm;

@end

@implementation Fuel
@synthesize _sprite;
@synthesize _fuelNorm;

+ (Fuel*) getObject
{
    if ( ! _s_fuel )
    {
        _s_fuel = [[Fuel alloc] init];
    }
    return _s_fuel;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        _sprite     = nil;
        _fuelNorm   = 1.0f;
    }
    return self;
}

- (void) LoadData
{
    _sprite = [CCSprite spriteWithFile:@"fuel_gauge.png"];
}

- (void) UnloadData
{
    // need doing something
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    [layer addChild:_sprite];
    
    CGFloat screenScale    = [[UIScreen mainScreen] scale];
    CGPoint fuelGaugePoint  = CGPointMake(10 * screenScale,
                                          40 * screenScale);
    
    [_sprite setPosition:fuelGaugePoint];
}

- (void) Update: (float) deltaTime
{
    if ( _sprite )
    {
        if ( _fuelNorm >= 0.75 )
        {
            ccColor3B color = {0, 255, 0};
            [_sprite setColor:color];
        }
        else if ( _fuelNorm >= 0.5 )
        {
            ccColor3B color = {255, 252, 10};
            [_sprite setColor:color];
        }
        else if ( _fuelNorm >= 0.25 )
        {
            ccColor3B color = {255, 131, 10};
            [_sprite setColor:color];
        }
        else
        {
            ccColor3B color = {255, 50, 10};
            [_sprite setColor:color];
        }
    }
}

- (void) SetFuelNorm: (float) fuelNorm // between 0.0 and 1.0
{
    _fuelNorm   = fuelNorm;
}

- (float) GetFuelNorm // between 0.0 and 1.0
{
    return _fuelNorm;
}

@end
