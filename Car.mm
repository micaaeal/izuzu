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
@property (assign) BOOL     isPlayingRoughAnim;
@property (assign) BOOL     isPlayingRoughAnimLastFrame;
@property (assign) BOOL     isPlayingAnyAnim;
@property (assign) BOOL     isPlayingAnyAnimLastFrame;
@property (assign) BOOL     isPlayingOvershootAnim;
@property (assign) BOOL     isPlayingOvershootAnimLastFrame;

@property (assign) float    animSwervePlayTime;
@property (assign) float    animRoughPlayTime;
@property (assign) float    animOvershootPlayTime;

@property (assign) CGPoint  animPointStamp;
@property (assign) float    animRotationStamp;

@property (assign) float    blinkPeriod;
@property (assign) float    blinkTimeRemained;

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
@synthesize isPlayingRoughAnim;
@synthesize isPlayingRoughAnimLastFrame;
@synthesize isPlayingAnyAnim;
@synthesize isPlayingAnyAnimLastFrame;
@synthesize isPlayingOvershootAnim;
@synthesize isPlayingOvershootAnimLastFrame;

@synthesize animSwervePlayTime;
@synthesize animRoughPlayTime;
@synthesize animOvershootPlayTime;

@synthesize animPointStamp;
@synthesize animRotationStamp;

@synthesize blinkPeriod;
@synthesize blinkTimeRemained;

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
        isPlayingRoughAnim              = NO;
        isPlayingRoughAnimLastFrame     = NO;
        isPlayingAnyAnim                = NO;
        isPlayingAnyAnimLastFrame       = NO;
        isPlayingOvershootAnim          = NO;
        isPlayingOvershootAnimLastFrame = NO;
        
        animSwervePlayTime      = 0.0f;
        animRoughPlayTime       = 0.0f;
        animOvershootPlayTime   = 0.0f;
        
        animPointStamp  = CGPointMake(0.0f, 0.0f);
        animRotationStamp   = 0.0f;
        
        blinkPeriod         = 0.3f;
        blinkTimeRemained   = 0.0f;
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
    BOOL isPlayingAnyAnim   = NO;
    
    /*
    if ( _carCache.isPlayingRoughAnim != _carCache.isPlayingRoughAnimLastFrame )
    {
        if ( _carCache.isPlayingRoughAnim )
        {
            _carCache.animRoughPlayTime  = 0.0f;
        }
        else if ( ! _carCache.isPlayingRoughAnim )
        {
            _carCache.animRoughPlayTime  = 0.0f;
        }
    }
    */
    
    // count time to make swerve animation stop
    if ( _carCache.isPlayingSwerveAnim )
    {
        _carCache.animSwervePlayTime += deltaTime;
        if ( _carCache.animSwervePlayTime >= 2.0f )
        {
            [Car stopAllAnim];
        }
    }
    
    // count time to make swerve animation stop 
    if ( _carCache.isPlayingOvershootAnim )
    {
        _carCache.animOvershootPlayTime += deltaTime;
        if ( _carCache.animOvershootPlayTime >= 2.0f )
        {
            [Car stopAllAnim];
        }
    }
    
    // start & stop swerve animation events
    if ( _carCache.isPlayingSwerveAnim != _carCache.isPlayingSwerveAnimLastFrame )
    {
        if ( _carCache.isPlayingSwerveAnim )
        {
            _carCache.animSwervePlayTime    = 0.0f;
            _carCache.animPointStamp        = _carCache.position;
            _carCache.animRotationStamp     = _carCache.rotation;
        }
        
        else if ( ! _carCache.isPlayingSwerveAnim )
        {
            _carCache.animSwervePlayTime    = 0.0f;
            [Car setPosition:_carCache.animPointStamp];
            [_carCache setRotation:_carCache.animRotationStamp];
            [Car setSpeed:0.0f];
        }
    }

    // start & stop overshoot animation events
    if ( _carCache.isPlayingOvershootAnim != _carCache.isPlayingOvershootAnimLastFrame )
    {
        if ( _carCache.isPlayingOvershootAnim )
        {
            _carCache.animOvershootPlayTime    = 0.0f;
            _carCache.animPointStamp        = _carCache.position;
            _carCache.animRotationStamp     = _carCache.rotation;
        }
        
        else if ( ! _carCache.isPlayingSwerveAnim )
        {
            _carCache.animOvershootPlayTime    = 0.0f;
            [Car setPosition:_carCache.animPointStamp];
            [_carCache setRotation:_carCache.animRotationStamp];
            [Car setSpeed:0.0f];
        }
    }
    
    // while playing swerve animation
    if ( _carCache.isPlayingSwerveAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        CGPoint position    = _carCache.position;
        position.y += (deltaTime*40.0f);
        position.x += (deltaTime*40.0f);
        [_carCache setPosition:position];
        
        [_carCache.carSprite setPosition:_carCache.position];
        
        _carCache.rotation += 200.0 * deltaTime;
        [_carCache.carSprite setRotation:_carCache.rotation];
    }
    
    // while playing swerve animation
    if ( _carCache.isPlayingOvershootAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        CGPoint position    = _carCache.position;
        position.y += (deltaTime*20.0f);
        position.x += (deltaTime*20.0f);
        [_carCache setPosition:position];
        
        [_carCache.carSprite setPosition:_carCache.position];
        
        _carCache.rotation -= 80.0 * deltaTime;
        [_carCache.carSprite setRotation:_carCache.rotation];
    }
    
    // update anim status
    _carCache.isPlayingSwerveAnimLastFrame      = _carCache.isPlayingSwerveAnim;
    _carCache.isPlayingRoughAnimLastFrame       = _carCache.isPlayingRoughAnim;
    _carCache.isPlayingOvershootAnimLastFrame   = _carCache.isPlayingOvershootAnim;
    _carCache.isPlayingAnyAnimLastFrame         = _carCache.isPlayingAnyAnim;
    
    if ( ! isPlayingAnyAnim )
    {
        // set car sprite
        [_carCache.carSprite setPosition:_carCache.position];
        [_carCache.carSprite setRotation:_carCache.rotation];
    }
    
    if ( _carCache.isPlayingRoughAnim )
    {
        [Car setRandomColor];
        isPlayingAnyAnim    = YES;
    }
    
    // car blink
    if ( _carCache.blinkTimeRemained >= 0.00001 )
    {
        float blinkPeriod       = _carCache.blinkPeriod;
        float blinkPeriod_2     = _carCache.blinkPeriod * 2.0f;
        int blinkBase           = int( _carCache.blinkTimeRemained / blinkPeriod_2 );
        float blinkRemained     = _carCache.blinkTimeRemained - ( (float)blinkBase * blinkPeriod_2 );
        float flag      = blinkRemained - blinkPeriod;
        if ( flag >= 0.0f )
        {
            [_carCache.carSprite setOpacity:0];
        }
        else
        {
            [_carCache.carSprite setOpacity:255];
        }
     
        _carCache.blinkTimeRemained -= deltaTime;
        if ( _carCache.blinkTimeRemained <= 0.00001 )
        {
            _carCache.blinkTimeRemained = 0.0f;
        }
    }
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

+ (void) setPosition: (CGPoint) position
{
    _carCache.position  = position;
}

+ (void) setTarget: (CGPoint) target
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

+ (void) hideCar
{
    [_carCache.carSprite setOpacity:0];
}

+ (void) showCar
{
    [_carCache.carSprite setOpacity:255];
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

+ (void) stopAllAnim
{
    [Car stopSwerveAnim];
    [Car stopRoughAnim];
    [Car stopOvershootAnim];
    _carCache.isPlayingAnyAnim      = NO;
}

+ (BOOL) isPlayingAnyAnim
{
    return _carCache.isPlayingAnyAnim;
}

// swerve animation
+ (void) playSwerveAnim
{
    _carCache.isPlayingSwerveAnim   = YES;
    _carCache.isPlayingAnyAnim      = YES;
}

+ (BOOL) isPlayingSwerveAnim
{
    return _carCache.isPlayingSwerveAnim;
}

+ (void) stopSwerveAnim
{
    _carCache.isPlayingSwerveAnim   = NO;
    [Car playBlinkWithTime:1.8f];
}

// rough animation
+ (void) playOvershootAnim
{
    _carCache.isPlayingOvershootAnim    = YES;
    _carCache.isPlayingAnyAnim          = YES;
}

+ (BOOL) isPlayingOvershootAnim
{
    return _carCache.isPlayingOvershootAnim;
}

+ (void) stopOvershootAnim
{
    _carCache.isPlayingOvershootAnim    = NO;
    [Car playBlinkWithTime:1.8f];
}

+ (void) playRoughAnim
{
    _carCache.isPlayingRoughAnim    = YES;
    _carCache.isPlayingAnyAnim      = YES;
}

+ (BOOL) isPlayingRoughAnim
{
    return _carCache.isPlayingRoughAnim;
}

+ (void) stopRoughAnim
{
    _carCache.isPlayingRoughAnim    = NO;
    [Car playBlinkWithTime:1.8f];
}

+ (void) playBlinkWithTime: (float) blinkTime
{
    _carCache.blinkTimeRemained     = blinkTime;
}

@end
