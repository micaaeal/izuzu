//
//  Car.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import "Car.h"
#import "Utils.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface CarCache: NSObject

@property (retain) CCSprite*    carSprite;
@property (assign) CGPoint      position;
@property (assign) CGFloat      rotation;
@property (assign) CGPoint      target;
@property (assign) float        speed;
@property (assign) CGPoint      directionUnitVec;

// animation
@property (assign) BOOL     isPlayingSwerveAnim;
@property (assign) BOOL     isPlayingSwerveAnimLastFrame;

@end
@implementation CarCache
@synthesize carSprite;
@synthesize position;
@synthesize rotation;
@synthesize target;
@synthesize speed;
@synthesize directionUnitVec;
@synthesize isPlayingSwerveAnim;
@synthesize isPlayingSwerveAnimLastFrame;

- (id) init
{
    self    = [super init];
    if (self)
    {
        carSprite   = NULL;
        position    = CGPointMake(0.0f, 0.0f);
        rotation    = 0.0f;
        target      = CGPointMake(0.0f, 0.0f);
        speed       = 1.0f;
        directionUnitVec    = CGPointMake(0.0f, 0.0f);
        
        isPlayingSwerveAnim             = NO;
        isPlayingSwerveAnimLastFrame    = NO;
    }
    return self;
}
- (void) dealloc
{
    [super dealloc];
}
@end

CarCache* _carCache = nil;

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation Car

+ (BOOL) LoadData
{
    // init cache
    _carCache   = [[CarCache alloc] init];
    
    // init car sprite
    _carCache.carSprite   = [CCSprite spriteWithFile:@"car_01_01_Run001.png"];
    [_carCache.carSprite setRotation:0.0f];
    
    CGFloat carScale    = _carCache.carSprite.scale;
    carScale    = [UtilVec convertScaleIfRetina:carScale];
    [_carCache.carSprite setScale:carScale];
    
    return YES;
}

+ (BOOL) UnloadData
{
    // @TODO Next
    
    [_carCache release];
    _carCache   = nil;
    
    return YES;
}

+ (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission
{
    [layer addChild:_carCache.carSprite];
    return YES;
}

+ (BOOL) UnSssignDataFromLayer: (CCLayer*) layer
{

    return YES;
}

+ (void) Update: (float) deltaTime
{

    // swerve animation
    if ( _carCache.isPlayingSwerveAnim != _carCache.isPlayingSwerveAnimLastFrame )
    {
        // play swerve
        if ( _carCache.isPlayingSwerveAnim == YES )
        {

        }
        // stop swerve
        if ( _carCache.isPlayingSwerveAnim == NO )
        {
            
        }
        
    }
    
    if ( _carCache.isPlayingSwerveAnim )
    {
        CGPoint carTarget   = CGPointMake(0.0f, 0.0f);
        [_carCache setTarget:carTarget];
    }
    
    // update anim status
    _carCache.isPlayingSwerveAnimLastFrame  = _carCache.isPlayingSwerveAnim;
    
    // set car sprite
    [_carCache.carSprite setPosition:_carCache.position];
    [_carCache.carSprite setRotation:_carCache.rotation];
    
}

#pragma mark - Reutines

+ (float) getSpeed
{
    return _carCache.speed;
}

+ (void) setSpeed: (float) speed
{
    _carCache.speed = speed;
}

+ (void) setPosition: (CGPoint&) position
{
    _carCache.position  = position;
}

+ (void) setTarget: (CGPoint&) target
{
    float deltaX    = target.x - _carCache.position.x;
    float deltaY    = target.y - _carCache.position.y;
    _carCache.target    = target;

    if ( _carCache.target.x == _carCache.position.x )
    {
        if ( _carCache.target.y == _carCache.position.y )
        {
            return;
        }
    }
    
    // set direction vec
    float range     = sqrtf( deltaX*deltaX + deltaY*deltaY );
    _carCache.directionUnitVec  = CGPointMake(deltaX/range, deltaY/range);
    
    // set rotation
    float radian    = atan2f(deltaY, deltaX);
    radian  = M_PI_2 - radian;
    float rotation  = (radian * 180.0f / M_PI );
    
    _carCache.rotation  = rotation;
}

+ (const CGPoint) getPosition
{
    return _carCache.position;
}

+ (const CGFloat) getRotation
{
    return _carCache.rotation;
}

+ (const CGPoint) getTarget
{
    return _carCache.target;
}

+ (const CGPoint) getDirectionUnitVec
{
    return _carCache.directionUnitVec;
}

+ (CGRect) getBoundingBox
{
    return _carCache.carSprite.boundingBox;
}

#pragma mark - events

+ (void) setRandomColor
{
    ccColor3B carColor = {arc4random() % 255,arc4random() % 255,arc4random() % 255};
    [_carCache.carSprite setColor:carColor];
}

+ (void) unsetRandomColor
{
    ccColor3B carColor = {255, 255, 255};
    [_carCache.carSprite setColor:carColor];
}

#pragma mark - animations

+ (void) playSwerveAnim
{
    _carCache.isPlayingSwerveAnim = YES;
}

+ (BOOL) isPlayingSwerveAnim
{
    return _carCache.isPlayingSwerveAnim;
}

+ (void) stopSwerveAnim
{
    _carCache.isPlayingSwerveAnim = NO;
}

@end
