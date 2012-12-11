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

@interface EventHandler()

@property (retain) NSMutableArray*  _eventArray;

@property (assign) CGPoint          _labelPoint;
@property (retain) CCSprite*        _labelWater;

@end

@implementation EventHandler
@synthesize delegate;
@synthesize _eventArray;
@synthesize _labelPoint;
@synthesize _labelWater;

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
    _labelWater = [CCSprite spriteWithFile:@"sign_car_water.png"];
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
    [uiLayer addChild:_labelWater];
    _labelWater.position    = _labelPoint;
    _labelWater.scale       = [UtilVec convertScaleIfRetina:_labelWater.scale];
    
    _labelWater.opacity = 0;
}

- (void) onUpdate: (float) deltaTime
{
    CGRect carRect  = [Car getBoundingBox];
    float carTop       = carRect.origin.y + carRect.size.height;
    float carBottom    = carRect.origin.y;
    float carLeft      = carRect.origin.x;
    float carRight     = carRect.origin.x + carRect.size.width;
    for (Event* cEvent in _eventArray)
    {
        CGRect cEventRect   = cEvent.sprite.boundingBox;
        CGPoint eventPoints[4];

        eventPoints[0]      = CGPointMake(cEventRect.origin.x,
                                          cEventRect.origin.y
                                          );
        eventPoints[1]      = CGPointMake(cEventRect.origin.x,
                                          cEventRect.origin.y + cEventRect.size.height
                                          );
        eventPoints[2]      = CGPointMake(cEventRect.origin.x + cEventRect.size.width,
                                          cEventRect.origin.y
                                          );
        eventPoints[3]      = CGPointMake(cEventRect.origin.x + cEventRect.size.width,
                                          cEventRect.origin.y + cEventRect.size.height
                                          );
        
        if ( [Car isPlayingAnyAnim] )
            continue;
        
        // check event touching
        BOOL isThisEventTouchTheCar = NO;
        for (int i=0; i<4; ++i)
        {
            CGPoint& cEventPoint    = eventPoints[i];
            if ( cEventPoint.x >= carLeft && cEventPoint.x <= carRight )
            {
                if ( cEventPoint.y >= carBottom && cEventPoint.y <= carTop )
                {
                    isThisEventTouchTheCar  = YES;
                    break;
                }
            }
        }
        
        if ( isThisEventTouchTheCar )
        {
            if ( cEvent.isTouching == NO )
            {
                if ( delegate )
                {
                    if ( [cEvent.eventName isEqualToString:@"water"] )
                    {
                        _labelWater.opacity = 255;
                    }
                    else if ( [cEvent.eventName isEqualToString:@"rough"] )
                    {
                        // need doing something
                    }
                        
                    [delegate onStartEvent:cEvent];                    
                }
            }
            
            cEvent.isTouching   = YES;
        }
        else
        {
            cEvent.isTouching   = NO;
        }
    }
}

- (void) finishAllEvents
{
    _labelWater.opacity = 0;
}

@end
