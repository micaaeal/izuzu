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
@property (retain) CCSprite*    speedLineSprite;
@property (retain) CCSprite*    speedLineEffect01;
@property (retain) CCSprite*    speedLineEffect02;
@property (retain) CCSprite*    speedLineEffect03;
@property (retain) CCSprite*    speedLineEffect04;

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
@property (assign) BOOL     isPlayingTurtleEffect;
@property (assign) BOOL     isPlayingTurtleEffectLastFrame;
@property (assign) BOOL     isPlayingSpeedLine;
@property (assign) BOOL     isPlayingSpeedLineLastFrame;

@property (assign) float    animSwervePlayTime;
@property (assign) float    animRoughPlayTime;
@property (assign) float    animOvershootPlayTime;
@property (assign) float    animTurtleEffectPlayTime;

@property (assign) CGPoint  animPointStamp;
@property (assign) float    animRotationStamp;

@property (assign) float    blinkPeriod;
@property (assign) float    blinkTimeRemained;

@end
@implementation CarCache
@synthesize carSprite;
@synthesize speedLineSprite;
@synthesize speedLineEffect01;
@synthesize speedLineEffect02;
@synthesize speedLineEffect03;
@synthesize speedLineEffect04;

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
@synthesize isPlayingTurtleEffect;
@synthesize isPlayingTurtleEffectLastFrame;
@synthesize isPlayingSpeedLine;
@synthesize isPlayingSpeedLineLastFrame;

@synthesize animSwervePlayTime;
@synthesize animRoughPlayTime;
@synthesize animOvershootPlayTime;
@synthesize animTurtleEffectPlayTime;

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
        speedLineSprite = NULL;
        speedLineEffect01   = NULL;
        speedLineEffect02   = NULL;
        speedLineEffect03   = NULL;
        speedLineEffect04   = NULL;
        
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
        isPlayingTurtleEffect           = NO;
        isPlayingTurtleEffectLastFrame  = NO;
        isPlayingSpeedLine              = NO;
        isPlayingSpeedLineLastFrame     = NO;
        
        animSwervePlayTime      = 0.0f;
        animRoughPlayTime       = 0.0f;
        animOvershootPlayTime   = 0.0f;
        animTurtleEffectPlayTime    = 0.0f;
        
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
    /*
     {
        _carCache.carSprite   = [CCSprite spriteWithFile:@"car_01_01_Run001.png"];
        [_carCache.carSprite setRotation:0.0f];
        
        CGFloat carScale    = _carCache.carSprite.scale;
        carScale    = [UtilVec convertScaleIfRetina:carScale];
        [_carCache.carSprite setScale:carScale];
    }
    /*/
    // init car sprite using texture atlas
    {
        CCSpriteFrameCache* frameCache  = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"car01_01.plist"];
        
        _carCache.carSprite = [CCSprite spriteWithSpriteFrameName:@"car01_01_EmptyAct01_000.png"];
        
        if ( _carCache.carSprite )
        {
            int frameCount          = 15;
            NSMutableArray* frames  = [NSMutableArray arrayWithCapacity:frameCount];
            for ( int i=0; i<frameCount; ++i )
            {
                NSString* file  = nil;
                if ( i < 10 )
                    file    = [NSString stringWithFormat:@"car01_01_EmptyAct01_00%d.png", i];
                else
                    file    = [NSString stringWithFormat:@"car01_01_EmptyAct01_0%d.png", i];
                
                CCSpriteFrame* frame    = [frameCache spriteFrameByName:file];
                [frames addObject:frame];
            }
            
            CCAnimation* anim   = [CCAnimation animationWithSpriteFrames:frames delay:0.08f];
            
            CCAnimate* animate  = [CCAnimate actionWithAnimation:anim];
            CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
            [_carCache.carSprite runAction:repeat];
        }
        
        CGFloat carScale    = _carCache.carSprite.scale;
        carScale    = [UtilVec convertScaleIfRetina:carScale];
        [_carCache.carSprite setScale:carScale];
    }
    /**/
    
    {
        _carCache.speedLineSprite   = [CCSprite spriteWithFile:@"speedline_048.png"];
        [_carCache.speedLineSprite setRotation:0.0f];
        
        [_carCache.speedLineSprite setScale:3.0f];
        CGFloat speedLineScale    = _carCache.speedLineSprite.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_carCache.speedLineSprite setScale:speedLineScale];
    }
    
    {
        _carCache.speedLineEffect01   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_carCache.speedLineEffect01 setRotation:0.0f];
        
        [_carCache.speedLineEffect01 setScale:1.0f];
        CGFloat speedLineScale    = _carCache.speedLineEffect01.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_carCache.speedLineEffect01 setScale:speedLineScale];
    }
    {
        _carCache.speedLineEffect02   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_carCache.speedLineEffect02 setRotation:0.0f];
        
        [_carCache.speedLineEffect02 setScale:1.0f];
        CGFloat speedLineScale    = _carCache.speedLineEffect02.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_carCache.speedLineEffect02 setScale:speedLineScale];
    }
    {
        _carCache.speedLineEffect03   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_carCache.speedLineEffect03 setRotation:0.0f];
        
        [_carCache.speedLineEffect03 setScale:1.0f];
        CGFloat speedLineScale    = _carCache.speedLineEffect03.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_carCache.speedLineEffect03 setScale:speedLineScale];
    }
    {
        _carCache.speedLineEffect04   = [CCSprite spriteWithFile:@"speedline_effect.png"];
        [_carCache.speedLineEffect04 setRotation:0.0f];
        
        [_carCache.speedLineEffect04 setScale:1.0f];
        CGFloat speedLineScale    = _carCache.speedLineEffect04.scale;
        speedLineScale    = [UtilVec convertScaleIfRetina:speedLineScale];
        [_carCache.speedLineEffect04 setScale:speedLineScale];
    }
    
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
    {
        [layer addChild:_carCache.speedLineSprite];
        _carCache.speedLineSprite.zOrder    = 8;
    }
    {
        [layer addChild:_carCache.speedLineEffect01];
        _carCache.speedLineEffect01.zOrder    = 9;
    }
    {
        [layer addChild:_carCache.speedLineEffect02];
        _carCache.speedLineEffect02.zOrder    = 9;
    }
    {
        [layer addChild:_carCache.speedLineEffect03];
        _carCache.speedLineEffect03.zOrder    = 9;
    }
    {
        [layer addChild:_carCache.speedLineEffect04];
        _carCache.speedLineEffect04.zOrder    = 9;
    }
    {
        [layer addChild:_carCache.carSprite];
        _carCache.carSprite.zOrder  = 10;
    }
    
    return YES;
}

+ (BOOL) UnSssignDataFromLayer: (CCLayer*) layer
{

    return YES;
}

+ (void) Update: (float) deltaTime
{
    BOOL isPlayingAnyAnim   = NO;

    // count time to make turtle animation stop
    if ( _carCache.isPlayingTurtleEffect )
    {
        _carCache.animTurtleEffectPlayTime += deltaTime;
        if ( _carCache.animTurtleEffectPlayTime >= 2.0f )
        {
            [Car stopAllAnim];
        }
    }
    
    // count time to make rough animation stop
    if ( _carCache.isPlayingRoughAnim )
    {
        _carCache.animRoughPlayTime += deltaTime;
        if ( _carCache.animRoughPlayTime >= 2.0f )
        {
            [Car stopAllAnim];
        }
    }
    
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
    
    // start & stop turtle animation events
    if ( _carCache.isPlayingTurtleEffect != _carCache.isPlayingTurtleEffectLastFrame )
    {
        if ( _carCache.isPlayingTurtleEffect )
        {
            _carCache.animTurtleEffectPlayTime    = 0.0f;
            _carCache.animPointStamp        = _carCache.position;
            _carCache.animRotationStamp     = _carCache.rotation;
        }
        
        else if ( ! _carCache.isPlayingTurtleEffect )
        {
            _carCache.animTurtleEffectPlayTime    = 0.0f;
            [Car setPosition:_carCache.animPointStamp];
            [_carCache setRotation:_carCache.animRotationStamp];
            [Car setSpeed:0.0f];
        }
    }
    
    // start & stop rough animation events
    if ( _carCache.isPlayingRoughAnim != _carCache.isPlayingRoughAnimLastFrame )
    {
        if ( _carCache.isPlayingRoughAnim )
        {
            _carCache.animRoughPlayTime    = 0.0f;
            _carCache.animPointStamp        = _carCache.position;
            _carCache.animRotationStamp     = _carCache.rotation;
        }
        
        else if ( ! _carCache.isPlayingRoughAnim )
        {
            _carCache.animRoughPlayTime    = 0.0f;
            [Car setPosition:_carCache.animPointStamp];
            [_carCache setRotation:_carCache.animRotationStamp];
            [Car setSpeed:0.0f];
            [Car unsetRandomColor];
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
        
        else if ( ! _carCache.isPlayingOvershootAnim )
        {
            _carCache.animOvershootPlayTime    = 0.0f;
            [Car setPosition:_carCache.animPointStamp];
            [_carCache setRotation:_carCache.animRotationStamp];
            [Car setSpeed:0.0f];
        }
    }
    
    // while playing turtle animation
    if ( _carCache.isPlayingTurtleEffect )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        CGPoint position    = _carCache.position;
        position.y += (deltaTime*40.0f);
        position.x += (deltaTime*40.0f);
        [_carCache setPosition:position];
        
        [_carCache.carSprite setPosition:_carCache.position];
        
        _carCache.rotation += 80.0 * deltaTime;
        [_carCache.carSprite setRotation:_carCache.rotation];
    }
    
    // while playing rough animation
    if ( _carCache.isPlayingRoughAnim )
    {
        isPlayingAnyAnim    = YES;
        
        // set car sprite
        CGPoint position    = _carCache.position;
        position.y += (deltaTime*40.0f);
        position.x += (deltaTime*40.0f);
        [_carCache setPosition:position];
        
        [_carCache.carSprite setPosition:_carCache.position];
        
        _carCache.rotation += 80.0 * deltaTime;
        [_carCache.carSprite setRotation:_carCache.rotation];
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
    

    if ( _carCache.isPlayingSpeedLine && ( ! _carCache.isPlayingSpeedLineLastFrame ) )
    {
        
        
    }
    
    // speed line
    if ( _carCache.isPlayingSpeedLine )
    {
        [_carCache.speedLineSprite setOpacity:255];
        [_carCache.speedLineEffect01 setOpacity:255];
        [_carCache.speedLineEffect02 setOpacity:255];
        [_carCache.speedLineEffect03 setOpacity:255];
        [_carCache.speedLineEffect04 setOpacity:255];
        
        [_carCache.speedLineSprite setPosition:_carCache.position];
        [_carCache.speedLineSprite setRotation:_carCache.rotation];

        float far    = 300.0f;
        CGPoint refPoint    = _carCache.position;
        
        float speed01     = 100.0f;
        float speed02     = 80.0f;
        float speed03     = 180.0f;
        float speed04     = 70.0f;
        
        float rotation  = _carCache.rotation;
        float radian    = rotation * M_PI / 180.0f;
        float dirX      = sinf(radian);
        float dirY      = cosf(radian);
        
        if ( ! _carCache.isPlayingSpeedLineLastFrame )
        {
            [_carCache.speedLineEffect01 setPosition:CGPointMake(refPoint.x + (dirX * far) - (dirY * 250.0f),
                                                                 refPoint.y + (dirY * far) - (dirX * 250.0f)
                                                                 )];
            [_carCache.speedLineEffect02 setPosition:CGPointMake(refPoint.x + (dirX * far) - (dirY * 80.0f),
                                                                 refPoint.y + (dirY * far) - (dirX * 80.0f)
                                                                 )];
            [_carCache.speedLineEffect03 setPosition:CGPointMake(refPoint.x + (dirX * far) + (dirY * 110.0f),
                                                                 refPoint.y + (dirY * far) + (dirX * 110.0f)
                                                                 )];
            [_carCache.speedLineEffect04 setPosition:CGPointMake(refPoint.x + (dirX * far) + (dirY * 280.0f),
                                                                 refPoint.y + (dirY * far) + (dirX * 280.0f)
                                                                 )];
        }
        
        {
            CGPoint positionLastFrame   = _carCache.speedLineEffect01.position;
            [_carCache.speedLineEffect01 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed01),
                                                                 positionLastFrame.y + (-dirY*speed01) )];
            [_carCache.speedLineEffect01 setRotation:_carCache.rotation];
        }
        {
            CGPoint positionLastFrame   = _carCache.speedLineEffect02.position;
            [_carCache.speedLineEffect02 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed02),
                                                                 positionLastFrame.y + (-dirY*speed02) )];
            [_carCache.speedLineEffect02 setRotation:_carCache.rotation];
        }
        {
            CGPoint positionLastFrame   = _carCache.speedLineEffect03.position;
            [_carCache.speedLineEffect03 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed03),
                                                                 positionLastFrame.y + (-dirY*speed03) )];
            [_carCache.speedLineEffect03 setRotation:_carCache.rotation];
        }
        {
            CGPoint positionLastFrame   = _carCache.speedLineEffect04.position;
            [_carCache.speedLineEffect04 setPosition:CGPointMake(positionLastFrame.x + (-dirX*speed04),
                                                                 positionLastFrame.y + (-dirY*speed04) )];
            [_carCache.speedLineEffect04 setRotation:_carCache.rotation];
        }

    }
    else
    {
        [_carCache.speedLineSprite setOpacity:0];
        [_carCache.speedLineEffect01 setOpacity:0];
        [_carCache.speedLineEffect02 setOpacity:0];
        [_carCache.speedLineEffect03 setOpacity:0];
        [_carCache.speedLineEffect04 setOpacity:0];
    }
    
    // update anim status
    _carCache.isPlayingSwerveAnimLastFrame      = _carCache.isPlayingSwerveAnim;
    _carCache.isPlayingRoughAnimLastFrame       = _carCache.isPlayingRoughAnim;
    _carCache.isPlayingOvershootAnimLastFrame   = _carCache.isPlayingOvershootAnim;
    _carCache.isPlayingAnyAnimLastFrame         = _carCache.isPlayingAnyAnim;
    _carCache.isPlayingTurtleEffectLastFrame    = _carCache.isPlayingTurtleEffect;
    _carCache.isPlayingSpeedLineLastFrame       = _carCache.isPlayingSpeedLine;
    
    int nos = _carCache.carSprite.numberOfRunningActions;
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
    // ..
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
    [Car stopTutleEffect];
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

+ (void) playTutleEffect
{
    _carCache.isPlayingTurtleEffect = YES;
    _carCache.isPlayingAnyAnim      = YES;
}

+ (BOOL) isPlayTutleEffect
{
    return _carCache.isPlayingTurtleEffect;
}

+ (void) stopTutleEffect
{
    _carCache.isPlayingTurtleEffect    = NO;
    [Car playBlinkWithTime:1.8f];
}

+ (void) playSpeedLine
{
    _carCache.isPlayingSpeedLine    = YES;
}

+ (BOOL) isPlayingSpeedLine
{
    return _carCache.isPlayingSpeedLine;
}

+ (void) stopSpeedLine
{
    _carCache.isPlayingSpeedLine    = NO;
}

+ (void) playBlinkWithTime: (float) blinkTime
{
    _carCache.blinkTimeRemained     = blinkTime;
}

@end
