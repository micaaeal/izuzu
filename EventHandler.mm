//
//  EventHandler.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/18/55 BE.
//
//

#import "EventHandler.h"
#import "Car.h"
#import "UtilVec.h"

EventHandler* _s_eventHandler   = nil;
float _activateEventDistance    = 150.0f;
float _deactivateEventDistance  = 350.0f;

@interface EventHandler()

@property (retain) NSMutableArray*  _eventArray;

@property (assign) CGPoint          _labelPoint;

@property (retain) CCSprite*        _signWater;
@property (retain) CCSprite*        _signRough;
@property (retain) CCSprite*        _signSpeedLimit;

@property (assign) Event*   _currentActivatingEvent;

- (void) _activateEvent: (Event*) event;
- (BOOL) _couldDeactivateCurrentEvent;
- (void) _deactivateCurrentEvent;

@end

@implementation EventHandler
@synthesize delegate;
@synthesize _eventArray;
@synthesize _labelPoint;

@synthesize _signWater;
@synthesize _signRough;
@synthesize _signSpeedLimit;

@synthesize _currentActivatingEvent;

+ (EventHandler*) getObject
{
    if ( ! _s_eventHandler )
    {
        _s_eventHandler = [[EventHandler alloc] init];
    }
    
    return _s_eventHandler;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        _eventArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_eventArray release];
    _eventArray = nil;
    
    [super dealloc];
}

- (void) onStart
{
    [_eventArray removeAllObjects];
    
    // load events from config file
    NSString* eventConfigFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"event_config.plist"];
    NSArray* eventConfigArray    = [[NSArray alloc] initWithContentsOfFile:eventConfigFullPath];

    int cEventCode    = 0;
    for (NSDictionary* cDict in eventConfigArray)
    {
        
        Event* cEvent  = [[Event alloc] init];
        
        cEvent.code         = [NSString stringWithFormat:@"%d", cEventCode];
        NSDictionary* pointDict = [cDict objectForKey:@"point"];
        cEvent.point    = CGPointMake(((NSString*)[pointDict objectForKey:@"x"]).floatValue,
                                      ((NSString*)[pointDict objectForKey:@"y"]).floatValue);
        NSString* eventName = [cDict objectForKey:@"eventName"];
        cEvent.eventName    = eventName;
        cEvent.isTouching   = NO;
        
        NSArray* comboList  = [[NSArray alloc] initWithArray:[cDict objectForKey:@"comboList"]];
        cEvent.comboList    = comboList;
        [comboList release];
        comboList   = nil;
        
        cEvent.comboTime    = [cDict objectForKey:@"comboTime"];
        
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    
    // load sprite
    CCSprite* signWater     = [CCSprite spriteWithFile:@"cuationSign03.png"];
    _signWater  = signWater;
    [signWater retain];
    [_signWater setScale:0.5];
    CCSprite* signRough     = [CCSprite spriteWithFile:@"cuationSign02.png"];
    _signRough  = signRough;
    [signRough retain];
    [_signRough setScale:0.5];
    CCSprite* signSpeedLimit    = [CCSprite spriteWithFile:@"speed_limit_sign.png"];
    _signSpeedLimit = signSpeedLimit;
    [signSpeedLimit retain];
    [_signSpeedLimit setScale:0.5];
}

- (void) onFinish
{
    [_eventArray removeAllObjects];
}

- (void) assignDataToActionLayer: (CCLayer*) actionLayer uiLayer: (CCLayer*) uiLayer
{
    for (Event* cEvent in _eventArray)
    {
        // load trigger sprite
        CCSprite* cSprite   = nil;
        if ( [cEvent.eventName isEqualToString:@"water"] )
        {
            cSprite = [CCSprite spriteWithFile:@"event_water.png"];
        }
        else if ( [cEvent.eventName isEqualToString:@"rough"] )
        {
            cSprite = [CCSprite spriteWithFile:@"event_rough.png"];
        }
        else if ( [cEvent.eventName isEqualToString:@"turtle"] )
        {
            cSprite = [CCSprite spriteWithFile:@"event_turtle.png"];            
        }
        
        cSprite.position    = CGPointMake(cEvent.point.x,
                                          cEvent.point.y);
        cEvent.sprite       = cSprite;
        [actionLayer addChild:cSprite];
        
        cSprite.scale   = [UtilVec convertScaleIfRetina:cSprite.scale];
    }
    
    // set label point
    // win size
    CGSize winSize          = [CCDirector sharedDirector].winSize;
    
    // meter
    _labelPoint  = CGPointMake(winSize.width - 40,
                               winSize.height - 120);
    // sprites
    [uiLayer addChild:_signWater];
    _signWater.position     = CGPointMake(_labelPoint.x - 20,
                                         _labelPoint.y - 40);
    _signWater.scale        = [UtilVec convertScaleIfRetina:_signWater.scale];
    _signWater.opacity = 0;
    
    [uiLayer addChild:_signRough];
    _signRough.position     = _signWater.position;
    _signRough.scale        = _signWater.scale;
    _signRough.opacity      = 0;
    
    [uiLayer addChild:_signSpeedLimit];
    _signSpeedLimit.position    = CGPointMake(_signWater.position.x,
                                              _signWater.position.y);
    _signSpeedLimit.scale   = [UtilVec convertScaleIfRetina:_signSpeedLimit.scale];
    _signSpeedLimit.opacity = 0;
}

- (void) onUpdate: (float) deltaTime
{
    // check to activate event
    CGPoint carPoint    = [[Car getObject] getPosition];
    for (Event* cEvent in _eventArray)
    {
        CGPoint cEventPoint = cEvent.point;
        
        float dx    = ABS( cEventPoint.x - carPoint.x );
        float dy    = ABS( cEventPoint.y - carPoint.y );
        
        float nearDistance  = _activateEventDistance;
        BOOL isCloseEnough  = ( nearDistance > ( dx + dy ) );
        
        if ( isCloseEnough )
        {
            cEvent.isTouching   = YES;
            
            if ( ! _currentActivatingEvent )
            {
                [self _activateEvent:cEvent];
            }
        }
        else
        {
            cEvent.isTouching   = NO;
        }
    }
    
    // check to deactivate the event
    if ( _currentActivatingEvent )
    {
        if ( [self _couldDeactivateCurrentEvent] )
        {
            [self _deactivateCurrentEvent];
        }
    }
}

- (BOOL) getIsShowAnyEvent
{
    BOOL isShowing  = NO;
    
    if ( _signWater.opacity == 255 )
        isShowing   = YES;
    if ( _signRough.opacity == 255 )
        isShowing   = YES;
    
    return isShowing;
}

- (void) finishAllEvents
{
    _signWater.opacity  = 0;
    _signRough.opacity  = 0;
}

#pragma mark - Customed Sign

- (void) showSpeedLimitSign
{
    [_signSpeedLimit setOpacity:255];
}

- (void) hideSpeedLimitSign
{
    [_signSpeedLimit setOpacity:0];
}

#pragma mark - PIMPL

- (void) _activateEvent: (Event*) event
{
    printf ("c activating evt address: %d", (int)_currentActivatingEvent);
    printf ("\n");
    
    _currentActivatingEvent = event;
 
    float px    = _currentActivatingEvent.point.x;
    float py    = _currentActivatingEvent.point.y;
    
    printf ("deactivate event AT point: (%f,%f)", px, py);
    printf ("\n");
    
    // play event
    if ( delegate )
    {
        if ( [event.eventName isEqualToString:@"water"] )
        {
            _signWater.opacity  = 255;
        }
        else if ( [event.eventName isEqualToString:@"rough"] )
        {
            _signRough.opacity  = 255;
        }
        
        [delegate onStartEvent:event];
    }
}

- (BOOL) _couldDeactivateCurrentEvent
{
    if ( ! _currentActivatingEvent )
        return NO;
    
    CGPoint cEventPoint = _currentActivatingEvent.point;
    CGPoint cCarPoint   = [[Car getObject] getPosition];
    
    float closeEnoughDistance   = _deactivateEventDistance;
    
    float dx    = ABS( cCarPoint.x - cEventPoint.x );
    float dy    = ABS( cCarPoint.y - cEventPoint.y );
    
    if ( dx + dy < closeEnoughDistance )
        return NO;
    
    return YES;
}

- (void) _deactivateCurrentEvent
{
    _currentActivatingEvent = nil;
}

@end
