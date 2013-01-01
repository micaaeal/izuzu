//
//  Car.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import "Car.h"
#import "Utils.h"
#import "Mission.h"
#import "MenuStates.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
Car* _car   = nil;

enum PICK_UP_STATE {
    PICK_UP_NOTHING = 0,
    PICK_UP_BOX,
    PICK_UP_REFRIGERATOR,
    PICK_UP_SOFA,
    };

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface Car()

@property (retain) CCSprite*    carSprite;
@property (retain) NSMutableArray*  carSpriteArray;
@property (retain) NSMutableArray*  carAnimArray;
@property (retain) NSArray*     carAnimNameArray;
@property (retain) CCSprite*    speedLineSprite;
@property (retain) CCSprite*    speedLineEffect01;
@property (retain) CCSprite*    speedLineEffect02;
@property (retain) CCSprite*    speedLineEffect03;
@property (retain) CCSprite*    speedLineEffect04;

@property (assign) CGPoint      position;
@property (assign) CGFloat      rotation;
@property (assign) CGPoint      _target;
@property (assign) float        speed;
@property (assign) CGPoint      directionUnitVec;

// animation
@property (assign) BOOL     _isPlayingSwerveAnim;
@property (assign) BOOL     isPlayingSwerveAnimLastFrame;
@property (assign) BOOL     _isPlayingRoughAnim;
@property (assign) BOOL     isPlayingRoughAnimLastFrame;
@property (assign) BOOL     isPlayingAnyAnimLastFrame;
@property (assign) BOOL     _isPlayingOvershootAnim;
@property (assign) BOOL     isPlayingOvershootAnimLastFrame;
@property (assign) BOOL     isPlayingTurtleEffect;
@property (assign) BOOL     isPlayingTurtleEffectLastFrame;
@property (assign) BOOL     _isPlayingSpeedLine;
@property (assign) BOOL     isPlayingSpeedLineLastFrame;

@property (assign) float    animSwervePlayTime;
@property (assign) float    animRoughPlayTime;
@property (assign) float    animOvershootPlayTime;
@property (assign) float    animTurtleEffectPlayTime;

@property (assign) CGPoint  animPointStamp;
@property (assign) float    animRotationStamp;

@property (assign) float    blinkPeriod;
@property (assign) float    blinkTimeRemained;

@property (assign) PICK_UP_STATE    currentPickUpState;
- (void) _loadCarResource;

@end

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation Car
@synthesize _target;
@synthesize _isPlayingSwerveAnim;
@synthesize _isPlayingOvershootAnim;
@synthesize _isPlayingRoughAnim;
@synthesize _isPlayingSpeedLine;

+ (Car*) getObject
{
    if ( ! _car )
    {
        _car    = [[Car alloc] init];
    }
    
    return _car;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        _carSprite   = NULL;
        _carSpriteArray = [[NSMutableArray alloc] init];
        _carAnimArray   = [[NSMutableArray alloc] init];
        _speedLineSprite = NULL;
        _speedLineEffect01   = NULL;
        _speedLineEffect02   = NULL;
        _speedLineEffect03   = NULL;
        _speedLineEffect04   = NULL;
        
        [self setPosition:CGPointMake(0.0f, 0.0f)];
        [self setRotation:0.0f];
        [self setTarget:CGPointMake(0.0f, 0.0f)];
        [self setSpeed:1.0f];
        _directionUnitVec    = CGPointMake(0.0f, 0.0f);
        
        _isPlayingSwerveAnim             = NO;
        _isPlayingSwerveAnimLastFrame    = NO;
        _isPlayingRoughAnim              = NO;
        _isPlayingRoughAnimLastFrame     = NO;
        _isPlayingAnyAnim                = NO;
        _isPlayingAnyAnimLastFrame       = NO;
        _isPlayingOvershootAnim          = NO;
        _isPlayingOvershootAnimLastFrame = NO;
        _isPlayingTurtleEffect           = NO;
        _isPlayingTurtleEffectLastFrame  = NO;
        _isPlayingSpeedLine              = NO;
        _isPlayingSpeedLineLastFrame     = NO;
        
        _animSwervePlayTime      = 0.0f;
        _animRoughPlayTime       = 0.0f;
        _animOvershootPlayTime   = 0.0f;
        _animTurtleEffectPlayTime    = 0.0f;
        
        _animPointStamp  = CGPointMake(0.0f, 0.0f);
        _animRotationStamp   = 0.0f;
        
        _blinkPeriod         = 0.3f;
        _blinkTimeRemained   = 0.0f;
        
        _currentPickUpState     = PICK_UP_NOTHING;
    }
    return self;
}
- (void) dealloc
{
    [_carAnimArray release];
    _carAnimArray   = nil;
    [_carSpriteArray release];
    _carSpriteArray = nil;
    
    [super dealloc];
}

- (BOOL) LoadData
{ 
    [self _loadCarResource];
    
    {
        _speedLineSprite   = [CCSprite spriteWithFile:@"speedline_048.png"];
        [_speedLineSprite retain];
        [_speedLineSprite setRotation:0.0f];
        
        [_speedLineSprite setScale:3.0f];
        CGFloat speedLineScale    = _speedLineSprite.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_speedLineSprite setScale:speedLineScale];
    }
    
    {
        _speedLineEffect01   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_speedLineEffect01 retain];
        [_speedLineEffect01 setRotation:0.0f];
        
        [_speedLineEffect01 setScale:1.0f];
        CGFloat speedLineScale    = _speedLineEffect01.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_speedLineEffect01 setScale:speedLineScale];
    }
    {
        _speedLineEffect02   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_speedLineEffect02 retain];
        [_speedLineEffect02 setRotation:0.0f];
        
        [_speedLineEffect02 setScale:1.0f];
        CGFloat speedLineScale    = _speedLineEffect02.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_speedLineEffect02 setScale:speedLineScale];
    }
    {
        _speedLineEffect03   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_speedLineEffect03 retain];
        [_speedLineEffect03 setRotation:0.0f];
        
        [_speedLineEffect03 setScale:1.0f];
        CGFloat speedLineScale    = _speedLineEffect03.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_speedLineEffect03 setScale:speedLineScale];
    }
    {
        _speedLineEffect04   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_speedLineEffect04 retain];
        [_speedLineEffect04 setRotation:0.0f];
        
        [_speedLineEffect04 setScale:1.0f];
        CGFloat speedLineScale    = _speedLineEffect04.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_speedLineEffect04 setScale:speedLineScale];
    }
    
    return YES;
}

- (BOOL) UnloadData
{
    // @TODO Next
    
    return YES;
}

- (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission
{
    {
        [layer addChild:_speedLineSprite];
        _speedLineSprite.zOrder    = 8;
    }
    {
        [layer addChild:_speedLineEffect01];
        _speedLineEffect01.zOrder    = 9;
    }
    {
        [layer addChild:_speedLineEffect02];
        _speedLineEffect02.zOrder    = 9;
    }
    {
        [layer addChild:_speedLineEffect03];
        _speedLineEffect03.zOrder    = 9;
    }
    {
        [layer addChild:_speedLineEffect04];
        _speedLineEffect04.zOrder    = 9;
    }
    /*
    {
        [layer addChild:_carSprite];
        _carSprite.zOrder   = 10;
    }
    */
    
    for ( CCSprite* cCarSprite in _carSpriteArray )
    {
        [layer addChild:cCarSprite];
        cCarSprite.zOrder   = 10;
        CGFloat carScale    = [UtilVec convertScaleIfRetina:1.0f];
        [cCarSprite setScale:carScale];
    }
    
    
    return YES;
}

- (BOOL) UnSssignDataFromLayer: (CCLayer*) layer
{
    return YES;
}

- (void) selectCarByIndex: (int) carIndex
{
    _carSprite  = [_carSpriteArray objectAtIndex:carIndex];
    int cCarState   = _currentPickUpState * 4;
    NSString* cCarAnimname  = [_carAnimNameArray objectAtIndex:(cCarState+0)];
    NSDictionary* cCarAnimDict  = [_carAnimArray objectAtIndex:carIndex];
    CCAnimation* cAnim  = [cCarAnimDict objectForKey:cCarAnimname];
    CCAnimate* animate  = [CCAnimate actionWithAnimation:cAnim];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    
    [_carSprite stopAllActions];
    [_carSprite runAction:repeat];
    
    _currentPickUpState = PICK_UP_NOTHING;
}

- (void) Update: (float) deltaTime
{
    BOOL isPlayingAnyAnim   = NO;

    // count time to make turtle animation stop
    /*
    if ( _isPlayingTurtleEffect )
    {
        _animTurtleEffectPlayTime += deltaTime;
        if ( _animTurtleEffectPlayTime >= 2.0f )
        {
            [self stopAllAnim];
        }
    }
    
    // count time to make rough animation stop
    if ( self.isPlayingRoughAnim )
    {
        _animRoughPlayTime += deltaTime;
        if ( _animRoughPlayTime >= 2.0f )
        {
            [self stopAllAnim];
        }
    }
    
    // count time to make swerve animation stop
    if ( self._isPlayingSwerveAnim )
    {
        _animSwervePlayTime += deltaTime;
        if ( _animSwervePlayTime >= 2.0f )
        {
            [self stopAllAnim];
        }
    }
    
    // count time to make swerve animation stop 
    if ( self.isPlayingOvershootAnim )
    {
        _animOvershootPlayTime += deltaTime;
        if ( _animOvershootPlayTime >= 2.0f )
        {
            [self stopAllAnim];
        }
    }
    */
    
    // in case ending of any animations, play defaults
    int isPlayingAnim    = [_carSprite numberOfRunningActions];
    if ( ! isPlayingAnim )
    {
        [self stopAllAnim];
    }
    
    // start & stop turtle animation events
    if ( _isPlayingTurtleEffect != _isPlayingTurtleEffectLastFrame )
    {
        if ( _isPlayingTurtleEffect )
        {
            _animTurtleEffectPlayTime    = 0.0f;
            _animPointStamp        = self.position;
            _animRotationStamp     = self.rotation;
        }
        
        else if ( ! _isPlayingTurtleEffect )
        {
            _animTurtleEffectPlayTime    = 0.0f;
            [self setPosition:_animPointStamp];
            [self setRotation:_animRotationStamp];
            [self setSpeed:0.0f];
        }
    }
    
    // start & stop rough animation events
    if ( self.isPlayingRoughAnim != _isPlayingRoughAnimLastFrame )
    {
        if ( self.isPlayingRoughAnim )
        {
            _animRoughPlayTime    = 0.0f;
            _animPointStamp        = self.position;
            _animRotationStamp     = self.rotation;
        }
        
        else if ( ! self.isPlayingRoughAnim )
        {
            _animRoughPlayTime    = 0.0f;
            [self setPosition:_animPointStamp];
            [self setRotation:_animRotationStamp];
            [self setSpeed:0.0f];
            [self unsetRandomColor];
        }
    }
    
    // start & stop swerve animation events
    if ( self._isPlayingSwerveAnim != self.isPlayingSwerveAnimLastFrame )
    {
        if ( self._isPlayingSwerveAnim )
        {
            _animSwervePlayTime    = 0.0f;
            _animPointStamp        = self.position;
            _animRotationStamp     = self.rotation;
        }
        
        else if ( ! self._isPlayingSwerveAnim )
        {
            _animSwervePlayTime    = 0.0f;
            [self setPosition:_animPointStamp];
            [self setRotation:_animRotationStamp];
            [self setSpeed:0.0f];
        }
    }

    // start & stop overshoot animation events
    if ( self.isPlayingOvershootAnim != self.isPlayingOvershootAnimLastFrame )
    {
        if ( self.isPlayingOvershootAnim )
        {
            _animOvershootPlayTime    = 0.0f;
            _animPointStamp        = self.position;
            _animRotationStamp     = self.rotation;
        }
        
        else if ( ! self.isPlayingOvershootAnim )
        {
            _animOvershootPlayTime    = 0.0f;
            [self setPosition:_animPointStamp];
            [self setRotation:_animRotationStamp];
            [self setSpeed:0.0f];
        }
    }
    
    // ---- ----
    // while playing turtle animation
    if ( _isPlayingTurtleEffect )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        float speed     = 20.0f;
        float radian    = self.rotation * M_PI / 180.0f;
        float dx        = speed * deltaTime * cosf(radian);
        float dy        = speed * deltaTime * sinf(radian);
        CGPoint position    = self.position;
        position.y += dx;
        position.x += dy;
        [self setPosition:position];
        [_carSprite setPosition:self.position];
    }
    
    // while playing rough animation
    if ( self.isPlayingRoughAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        float speed     = 20.0f;
        float radian    = self.rotation * M_PI / 180.0f;
        float dx        = speed * deltaTime * cosf(radian);
        float dy        = speed * deltaTime * sinf(radian);
        CGPoint position    = self.position;
        position.y += dx;
        position.x += dy;
        [self setPosition:position];
        [_carSprite setPosition:self.position];
    }
    
    // while playing swerve animation
    if ( self._isPlayingSwerveAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        float speed     = 20.0f;
        float radian    = self.rotation * M_PI / 180.0f;
        float dx        = speed * deltaTime * cosf(radian);
        float dy        = speed * deltaTime * sinf(radian);
        CGPoint position    = self.position;
        position.y += dx;
        position.x += dy;
        [self setPosition:position];
        [_carSprite setPosition:self.position];
    }
    
    // while playing swerve animation
    if ( self.isPlayingOvershootAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        float speed     = 20.0f;
        float radian    = self.rotation * M_PI / 180.0f;
        float dx        = speed * deltaTime * cosf(radian);
        float dy        = speed * deltaTime * sinf(radian);
        CGPoint position    = self.position;
        position.y += dx;
        position.x += dy;
        [self setPosition:position];
        [_carSprite setPosition:self.position];
    }
    // ---- ----
    
    if ( ! isPlayingAnyAnim )
    {
        // set car sprite
        [_carSprite setPosition:self.position];
        [_carSprite setRotation:self.rotation];
    }
    
    // car blink
    if ( _blinkTimeRemained >= 0.00001 )
    {
        float blinkPeriod       = _blinkPeriod;
        float blinkPeriod_2     = _blinkPeriod * 2.0f;
        int blinkBase           = int( _blinkTimeRemained / blinkPeriod_2 );
        float blinkRemained     = _blinkTimeRemained - ( (float)blinkBase * blinkPeriod_2 );
        float flag      = blinkRemained - blinkPeriod;
        if ( flag >= 0.0f )
        {
            [_carSprite setOpacity:0];
        }
        else
        {
            [_carSprite setOpacity:255];
        }
     
        _blinkTimeRemained -= deltaTime;
        if ( _blinkTimeRemained <= 0.00001 )
        {
            _blinkTimeRemained = 0.0f;
        }
    }
    
    // speed line
    if ( self._isPlayingSpeedLine )
    {
        [_speedLineSprite setOpacity:255];
        [_speedLineEffect01 setOpacity:255];
        [_speedLineEffect02 setOpacity:255];
        [_speedLineEffect03 setOpacity:255];
        [_speedLineEffect04 setOpacity:255];
        
        [_speedLineSprite setPosition:self.position];
        [_speedLineSprite setRotation:self.rotation];

        float far    = 300.0f;
        CGPoint refPoint    = self.position;
        
        float speed01     = 100.0f;
        float speed02     = 80.0f;
        float speed03     = 180.0f;
        float speed04     = 70.0f;
        
        float rotation  = self.rotation;
        float radian    = rotation * M_PI / 180.0f;
        float dirX      = sinf(radian);
        float dirY      = cosf(radian);
        
        if ( ! _isPlayingSpeedLineLastFrame )
        {
            [_speedLineEffect01 setPosition:CGPointMake(refPoint.x + (dirX * far) - (dirY * 250.0f),
                                                                 refPoint.y + (dirY * far) - (dirX * 250.0f)
                                                                 )];
            [_speedLineEffect02 setPosition:CGPointMake(refPoint.x + (dirX * far) - (dirY * 80.0f),
                                                                 refPoint.y + (dirY * far) - (dirX * 80.0f)
                                                                 )];
            [_speedLineEffect03 setPosition:CGPointMake(refPoint.x + (dirX * far) + (dirY * 110.0f),
                                                                 refPoint.y + (dirY * far) + (dirX * 110.0f)
                                                                 )];
            [_speedLineEffect04 setPosition:CGPointMake(refPoint.x + (dirX * far) + (dirY * 280.0f),
                                                                 refPoint.y + (dirY * far) + (dirX * 280.0f)
                                                                 )];
        }
        
        {
            CGPoint positionLastFrame   = _speedLineEffect01.position;
            [_speedLineEffect01 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed01),
                                                                 positionLastFrame.y + (-dirY*speed01) )];
            [_speedLineEffect01 setRotation:self.rotation];
        }
        {
            CGPoint positionLastFrame   = _speedLineEffect02.position;
            [_speedLineEffect02 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed02),
                                                                 positionLastFrame.y + (-dirY*speed02) )];
            [_speedLineEffect02 setRotation:self.rotation];
        }
        {
            CGPoint positionLastFrame   = _speedLineEffect03.position;
            [_speedLineEffect03 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed03),
                                                                 positionLastFrame.y + (-dirY*speed03) )];
            [_speedLineEffect03 setRotation:self.rotation];
        }
        {
            CGPoint positionLastFrame   = _speedLineEffect04.position;
            [_speedLineEffect04 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed04),
                                                                 positionLastFrame.y + (-dirY*speed04) )];
            [_speedLineEffect04 setRotation:self.rotation];
        }

    }
    else
    {
        [_speedLineSprite setOpacity:0];
        [_speedLineEffect01 setOpacity:0];
        [_speedLineEffect02 setOpacity:0];
        [_speedLineEffect03 setOpacity:0];
        [_speedLineEffect04 setOpacity:0];
    }
    
    // update anim status
    _isPlayingSwerveAnimLastFrame      = self._isPlayingSwerveAnim;
    _isPlayingRoughAnimLastFrame       = self.isPlayingRoughAnim;
    _isPlayingOvershootAnimLastFrame   = self.isPlayingOvershootAnim;
    _isPlayingAnyAnimLastFrame         = isPlayingAnyAnim;
    _isPlayingTurtleEffectLastFrame    = _isPlayingTurtleEffect;
    _isPlayingSpeedLineLastFrame       = self._isPlayingSpeedLine;
}

#pragma mark - Reutines

- (float) getSpeed
{
    return self.speed;
}

- (void) setTarget: (CGPoint) target
{
    float deltaX    = target.x - self.position.x;
    float deltaY    = target.y - self.position.y;
    _target = target;
    
    if ( _target.x == self.position.x )
    {
        if ( _target.y == self.position.y )
        {
            return;
        }
    }
    
    // set direction vec
    float range     = sqrtf( deltaX*deltaX + deltaY*deltaY );
    _directionUnitVec  = CGPointMake(deltaX/range, deltaY/range);
    
    // set rotation
    float radian    = atan2f(deltaY, deltaX);
    radian  = M_PI_2 - radian;
    float rotation  = (radian * 180.0f / M_PI );
    
    self.rotation  = rotation;
}

- (const CGPoint) getPosition
{
    return self.position;
}

- (const CGFloat) getRotation
{
    return self.rotation;
}

- (const CGPoint) getTarget
{
    return _target;
}

- (const CGPoint) getDirectionUnitVec
{
    return _directionUnitVec;
}

- (CGRect) getBoundingBox
{
    return _carSprite.boundingBox;
}

- (void) hideCar
{
    [_carSprite setOpacity:0];
}

- (void) showCar
{
    [_carSprite setOpacity:255];
}

#pragma mark - events

- (void) setRandomColor
{
    ccColor3B carColor = {arc4random() % 255,arc4random() % 255,arc4random() % 255};
    [_carSprite setColor:carColor];
}

- (void) unsetRandomColor
{
    ccColor3B carColor = {255, 255, 255};
    [_carSprite setColor:carColor];
}

#pragma mark - picked up functions

- (void) pickUpNothing
{
    _currentPickUpState = PICK_UP_NOTHING;
}

- (void) pickUpBox
{
    _currentPickUpState = PICK_UP_BOX;
}

- (void) pickUpRefrigerator
{
    _currentPickUpState = PICK_UP_REFRIGERATOR;
}

- (void) pickUpSofa
{
    _currentPickUpState = PICK_UP_SOFA;
}

#pragma mark - animations

- (void) stopAllAnim
{
    [self stopSwerveAnim];
    [self stopRoughAnim];
    [self stopOvershootAnim];
    [self stopTutleEffect];
    _isPlayingAnyAnim      = NO;
    
    int cCarState   = _currentPickUpState * 4;
    NSString* cCarAnimname  = [_carAnimNameArray objectAtIndex:(cCarState+0)];
    int carIndex    = [MenuStates getObject].carCode;
    NSDictionary* cCarAnimDict  = [_carAnimArray objectAtIndex:carIndex];
    CCAnimation* cAnim  = [cCarAnimDict objectForKey:cCarAnimname];
    CCAnimate* animate  = [CCAnimate actionWithAnimation:cAnim];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    
    [_carSprite stopAllActions];
    [_carSprite runAction:repeat];
}

// swerve animation
- (void) playSwerveAnim
{
    _isPlayingSwerveAnim   = YES;
    _isPlayingAnyAnim      = YES;
    
    int cCarState   = _currentPickUpState * 4;
    NSString* cCarAnimname  = [_carAnimNameArray objectAtIndex:(cCarState+1)];
    int carIndex    = [MenuStates getObject].carCode;
    NSDictionary* cCarAnimDict  = [_carAnimArray objectAtIndex:carIndex];
    CCAnimation* cAnim  = [cCarAnimDict objectForKey:cCarAnimname];
    CCAnimate* animate  = [CCAnimate actionWithAnimation:cAnim];
    
    [_carSprite stopAllActions];
    [_carSprite runAction:animate];
}

- (void) stopSwerveAnim
{
    _isPlayingSwerveAnim   = NO;
    [self playBlinkWithTime:1.8f];
}

// rough animation
- (void) playOvershootAnim
{
    _isPlayingOvershootAnim    = YES;
    _isPlayingAnyAnim          = YES;
    
    int cCarState   = _currentPickUpState * 4;
    NSString* cCarAnimname  = [_carAnimNameArray objectAtIndex:(cCarState+3)];
    int carIndex    = [MenuStates getObject].carCode;
    NSDictionary* cCarAnimDict  = [_carAnimArray objectAtIndex:carIndex];
    CCAnimation* cAnim  = [cCarAnimDict objectForKey:cCarAnimname];
    CCAnimate* animate  = [CCAnimate actionWithAnimation:cAnim];
    
    [_carSprite stopAllActions];
    [_carSprite runAction:animate];
}

- (BOOL) isPlayingOvershootAnim
{
    return _isPlayingOvershootAnim;
}

- (void) stopOvershootAnim
{
    _isPlayingOvershootAnim    = NO;
    [self playBlinkWithTime:1.8f];
}

- (void) playRoughAnim
{
    _isPlayingRoughAnim    = YES;
    _isPlayingAnyAnim      = YES;
    
    int cCarState   = _currentPickUpState * 4;
    NSString* cCarAnimname  = [_carAnimNameArray objectAtIndex:(cCarState+2)];
    int carIndex    = [MenuStates getObject].carCode;
    NSDictionary* cCarAnimDict  = [_carAnimArray objectAtIndex:carIndex];
    CCAnimation* cAnim  = [cCarAnimDict objectForKey:cCarAnimname];
    CCAnimate* animate  = [CCAnimate actionWithAnimation:cAnim];
    
    [_carSprite stopAllActions];
    [_carSprite runAction:animate];
}

- (BOOL) isPlayingRoughAnim
{
    return _isPlayingRoughAnim;
}

- (void) stopRoughAnim
{
    _isPlayingRoughAnim    = NO;
    [self playBlinkWithTime:1.8f];
}

- (void) playTutleEffect
{
    _isPlayingTurtleEffect = YES;
    _isPlayingAnyAnim      = YES;
}

- (BOOL) isPlayTutleEffect
{
    return _isPlayingTurtleEffect;
}

- (void) stopTutleEffect
{
    _isPlayingTurtleEffect    = NO;
    [self playBlinkWithTime:1.8f];
}

- (void) playSpeedLine
{
    _isPlayingSpeedLine    = YES;
}

- (void) stopSpeedLine
{
    _isPlayingSpeedLine    = NO;
}

- (void) playBlinkWithTime: (float) blinkTime
{
    _blinkTimeRemained     = blinkTime;
}

#pragma mark - PIMPL

- (void) _loadCarResource
{
    // init car sprite using texture atlas
    NSArray* carNameArray   = [[NSArray alloc] initWithObjects:
                               @"car01_01",
                               @"car01_03",
                               @"car01_02",
                               @"car02_02",
                               @"car02_01",
                               @"car02_03",
                               nil];
    
    _carAnimNameArray   = [[NSArray alloc] initWithObjects:
                               @"EmptyAct01", @"EmptyAct02", @"EmptyAct03", @"EmptyAct04",
                               @"BoxAct01", @"BoxAct02", @"BoxAct03", @"BoxAct04",
                               @"RefrigAct01", @"RefrigAct02", @"RefrigAct03", @"RefrigAct04",
                               @"SofaAct01", @"SofaAct02", @"SofaAct03", @"SofaAct04",
                               nil];
    
    int animFrameCount[]    = { 15, 16, 8, 22,
                                15, 16, 8, 22,
                                15, 16, 8, 22,
                                15, 16, 8, 22
                                };
    
    // load all cars
    for ( int i=0; i<carNameArray.count; ++i )
    {
        // car name
        NSString* cCarName  = [carNameArray objectAtIndex:i];
        
        // car plist
        CCSpriteFrameCache* frameCache  = [CCSpriteFrameCache sharedSpriteFrameCache];
        NSString* pListStr  = [[NSString alloc] initWithFormat:@"%@.plist", cCarName];
        NSString* textureStr    = [[NSString alloc] initWithFormat:@"%@.png", cCarName];
        [frameCache addSpriteFramesWithFile:pListStr textureFilename:textureStr];
        [textureStr release];
        textureStr    = nil;
        [pListStr release]; pListStr    = nil;
        
        // car sprite
        NSString* firstCarAnimStr   = [_carAnimNameArray objectAtIndex:0];
        NSString* spriteStr         = [[NSString alloc] initWithFormat:@"%@_%@_000.png", cCarName, firstCarAnimStr];
        
        CCSprite* cCarSprite = [CCSprite spriteWithSpriteFrameName:spriteStr];
        [_carSpriteArray addObject:cCarSprite];
        
        [spriteStr release]; spriteStr  = nil;
        
        // load car anims
        NSMutableDictionary* cCarAnimDict   = [[NSMutableDictionary alloc] init];
        for ( int j=0; j<_carAnimNameArray.count; ++j )
        {
            // load anim name
            NSString* cCarAnimName  = [_carAnimNameArray objectAtIndex:j];
            
            // load anim frame count
            int cFrameCount = animFrameCount[j];
            NSMutableArray* frames  = [[NSMutableArray alloc] initWithCapacity:cFrameCount];
            
            // load animation frames
            for ( int k=0; k<cFrameCount; ++k )
            //for ( int k=0; k<10; ++k )
            {
                NSString* file  = nil;
                if ( k < 10 )
                    file    = [NSString stringWithFormat:@"%@_%@_00%d.png", cCarName, cCarAnimName, k];
                else
                    file    = [NSString stringWithFormat:@"%@_%@_0%d.png", cCarName, cCarAnimName, k];

                CCSpriteFrame* frame    = [frameCache spriteFrameByName:file];
                [frames addObject:frame];
            }

            CCAnimation* anim   = [CCAnimation animationWithSpriteFrames:frames delay:0.12f];
            [cCarAnimDict setObject:anim forKey:cCarAnimName];
        }
        
        // add car anim dict to array
        [_carAnimArray addObject:cCarAnimDict];
    }
}

@end
