//
//  MenuRouteGuide.mm
//  DriftForever
//
//  Created by Adawat Chanchua on 2/17/56 BE.
//
//

#import "MenuRouteGuide.h"
#import "UtilVec.h"

@interface MenuRouteGuide()

@property (retain) CCSprite*             _good_arrow;
@property (retain) CCSprite*             _light;
@property (retain) CCSprite*             _targetOff;
@property (retain) CCSprite*             _targetOn;

@end

@implementation MenuRouteGuide
@synthesize _good_arrow;
@synthesize _light;
@synthesize _targetOff;
@synthesize _targetOn;

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _good_arrow         = nil;
        _light              = nil;
        _targetOn           = nil;
        _targetOff          = nil;
    }
    return self;
}

- (void) dealloc
{
    [_good_arrow removeFromParentAndCleanup:YES];
    [_light removeFromParentAndCleanup:YES];
    [_targetOn removeFromParentAndCleanup:YES];
    [_targetOff removeFromParentAndCleanup:YES];

    [super dealloc];
}

- (void) loadDataToLayer: (CCLayer*) rootLayer
{

    CCTexture2DPixelFormat prierPixFormat   = CCTexture2D.defaultAlphaPixelFormat;
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    // load good arrow
    {
        CCSprite* sprite = [CCSprite spriteWithFile: @"good_arrow.png"];
        sprite.position = CGPointMake(0.0f, 0.0f);
        [rootLayer addChild:sprite];
        
        CGFloat spriteScale = [UtilVec convertScaleIfRetina:sprite.scale];
        [sprite setScale:spriteScale];
        
        _good_arrow = sprite;
    }
    
    // load light
    {
        CCSprite* sprite = [CCSprite spriteWithFile: @"light.png"];
        sprite.position = CGPointMake(0.0f, 0.0f);
        [rootLayer addChild:sprite];
        
        CGFloat spriteScale = [UtilVec convertScaleIfRetina:sprite.scale];
        [sprite setScale:spriteScale];
        
        [sprite setAnchorPoint:CGPointMake(0.5, 0.0f)];
        
        _light = sprite;
    }
    
    // load target on
    {
        CCSprite* sprite = [CCSprite spriteWithFile: @"target_green.png"];
        sprite.position = CGPointMake(0.0f, 0.0f);
        [rootLayer addChild:sprite];
        
        CGFloat spriteScale = [UtilVec convertScaleIfRetina:sprite.scale];
        [sprite setScale:spriteScale];
        
        _targetOn = sprite;
    }
    
    // load target off
    {
        CCSprite* sprite = [CCSprite spriteWithFile: @"target_red.png"];
        sprite.position = CGPointMake(0.0f, 0.0f);
        [rootLayer addChild:sprite];
        
        CGFloat spriteScale = [UtilVec convertScaleIfRetina:sprite.scale];
        [sprite setScale:spriteScale];
        
        _targetOff = sprite;
    }
    
    [CCTexture2D setDefaultAlphaPixelFormat:prierPixFormat];
}

- (void) showLight
{
    [_light setOpacity:255];
}

- (void) hideLight
{
    [_light setOpacity:0];
}

- (void) setLightPoserFrom:(CGPoint) from to:(CGPoint) to
{
    // set position
    _light.position = from;
    
    // rotation
    float difX      = to.x - from.x;
    float difY      = to.y - from.y;
    float radian    = atan2f(difX, difY);
    
    _light.rotation = radian * 180.0f / M_PI;
    
    // scale
    float length        = sqrtf( difX*difX + difY*difY );
    
    float lightScaleY   = ( length / _light.textureRect.size.height );
    
    [_light setScaleY:lightScaleY];
}

- (void) showRouteTarget
{
    [_targetOn setOpacity:0];
    [_targetOff setOpacity:255];
}

- (void) hideRouteTarget
{
    [_targetOn setOpacity:0];
    [_targetOff setOpacity:0];
}

- (void) setRouteTargetPosition:(CGPoint) position
{
    _targetOff.position = position;
    _targetOn.position  = position;
}

- (void) setRouteTargetState: (BOOL) isOnOrOff
{
    if ( isOnOrOff )
    {
        [_targetOn setOpacity:255];
        [_targetOff setOpacity:0];
        return;
    }
    [_targetOn setOpacity:0];
    [_targetOff setOpacity:255];
}

@end
