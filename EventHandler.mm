//
//  EventHandler.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/18/55 BE.
//
//

#import "EventHandler.h"
#import "Car.h"

EventHandler* _s_eventHandler   = nil;

@interface EventHandler()

@property (retain) NSMutableArray* _eventArray;

@end

@implementation EventHandler
@synthesize delegate;
@synthesize _eventArray;

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
    
    int cEventCode    = 0;
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(6031.833496, -4753.666992);
        cEvent.typeName = @"water";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(6815.833496, -4769.666992);
        cEvent.typeName = @"rough";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(5559.833496, -4317.666992);
        cEvent.typeName = @"rough";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(5823.833496, -3805.666992);
        cEvent.typeName = @"water";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(6835.833496, -3797.666992);
        cEvent.typeName = @"rough";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
    {
        Event* cEvent   = [[Event alloc] init];
        cEvent.code     = [NSString stringWithFormat:@"%d", cEventCode];
        cEvent.point    = CGPointMake(7051.833496, -4225.666992);
        cEvent.typeName = @"water";
        cEvent.isTouching   = NO;
        [_eventArray addObject:cEvent];
        ++cEventCode;
    }
}

- (void) onFinish
{
    [_eventArray removeAllObjects];
}

- (void) assignDataToLayer: (CCLayer*) layer
{
    for (Event* cEvent in _eventArray)
    {
        // load trigger sprite
        CCSprite* cSprite   = nil;
        if ( [cEvent.typeName isEqualToString:@"water"] )
        {
            cSprite = [CCSprite spriteWithFile:@"event_water.png"];
        }
        else if ( [cEvent.typeName isEqualToString:@"rough"] )
        {
            cSprite = [CCSprite spriteWithFile:@"event_rough.png"];
        }
        cSprite.position    = CGPointMake(cEvent.point.x,
                                          cEvent.point.y);
        cEvent.sprite       = cSprite;
        [layer addChild:cSprite];
    }
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
        
        BOOL isThisEventTouchTheCar = NO;
        for (int i=0; i<4; ++i)
        {
            CGPoint& cEventPoint    = eventPoints[i];
            if ( cEventPoint.x >= carLeft && cEventPoint.x <= carRight )
            {
                if ( cEventPoint.y >= carBottom && cEventPoint.y <= carTop )
                {
                    isThisEventTouchTheCar  = YES;
                }
            }
        }
        
        if ( isThisEventTouchTheCar )
        {
            if ( cEvent.isTouching == NO )
            {
                if ( delegate )
                {
                    [delegate onTouchingInWithEvent:cEvent];
                }
            }
            
            cEvent.isTouching   = YES;
        }
        else
        {
            if ( cEvent.isTouching == YES )
            {
                if ( delegate )
                {
                    [delegate onTouchingOutWithEvent:cEvent];
                }
            }
            
            cEvent.isTouching   = NO;
        }
    }
}

@end
