//
//  EventHandler.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/18/55 BE.
//
//

#import "EventHandler.h"

#import "Event.h"
#import "Combo.h"

@interface EventHandler()

@property (retain) NSMutableArray* _eventArray;

@end

@implementation EventHandler
@synthesize _eventArray;

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
    
    // create event
    float eventStandardSize = 300.0f;
    {
        Event* cEvent   = [[Event alloc] init];
#warning .. to be continued here
    }
    
}

- (void) onFinish
{
    [_eventArray removeAllObjects];
}

- (void) onUpdate: (float) deltaTime
{
    
}

@end
