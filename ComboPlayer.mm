//
//  ComboPlayer.m
//  DriftForever
//
//  Created by ADAWAT on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComboPlayer.h"
#import "EventHandler.h"
#import "UtilVec.h"

static ComboPlayer* _s_object   = nil;
CGPoint buttonPointArray[3];

@interface ComboPlayer()

// combo list
@property (assign) CGPoint  comboListPointRef;
@property (assign) float    comboListSpace;
@property (assign) int      currentComboIndex;
@property (retain) Event*   currentEvent;
@property (assign) float    comboTime;
@property (retain) Event*   overShootEvent;

@property (retain) NSMutableDictionary* comboButtonDict;
@property (retain) NSMutableArray*  buttonSpriteArray;
@property (retain) NSMutableArray*  comboSpriteArray;
@property (retain) NSMutableArray*  comboNumberArray;
@property (retain) CCSprite*    comboArrowSprite;

@property (assign) BOOL hasAddResourcesToLayer;

@end

@implementation ComboPlayer
@synthesize comboListPointRef;
@synthesize comboListSpace;
@synthesize currentComboIndex;
@synthesize currentEvent;
@synthesize comboTime;
@synthesize comboButtonDict;
@synthesize buttonSpriteArray;
@synthesize comboSpriteArray;
@synthesize comboNumberArray;
@synthesize comboArrowSprite;
@synthesize delegate;
@synthesize hasAddResourcesToLayer;
@synthesize overShootEvent;

+ (ComboPlayer*) getObject
{
    if ( ! _s_object )
    {
        _s_object   = [[ComboPlayer alloc] init];
        
        CGSize winSize          = [CCDirector sharedDirector].winSize;
        
        if ( winSize.height < 321.0f && winSize.width < 481.0f ) // iPhone win size
        {
            _s_object.comboListPointRef = CGPointMake(120.0f, 250.0f);
        }
        else if ( winSize.height < 321.0f && winSize.width >= 481.0f ) // iPhone 5
        {
            _s_object.comboListPointRef = CGPointMake(170.0f, 250.0f);
        }
        else
        {
            _s_object.comboListPointRef = CGPointMake(400.0f, 600.0f);
        }
        
        _s_object.hasAddResourcesToLayer    = NO;
    }
    
    return _s_object;
}

- (id) init
{
    self    = [super init];
    if (self)
    {
        comboListSpace    = 70.0f;
        currentComboIndex = 0;
        currentEvent      = nil;
        comboTime         = 0.0f;
        comboSpriteArray  = [[NSMutableArray alloc] init];
        comboNumberArray  = [[NSMutableArray alloc] init];
        buttonSpriteArray = [[NSMutableArray alloc] init];
        comboButtonDict   = [[NSMutableDictionary alloc] init];
        delegate          = nil;
        overShootEvent    = [[Event alloc] init];
        overShootEvent.comboTime    = @"3";
        overShootEvent.eventName    = @"over_shoot";
    }
    return self;
}

- (void) dealloc
{
    [overShootEvent release];
    overShootEvent  = nil;
    [comboSpriteArray release];
    comboSpriteArray    = nil;
    [comboNumberArray release];
    comboNumberArray    = nil;
    [buttonSpriteArray release];
    buttonSpriteArray   = nil;
    [comboButtonDict release];
    comboButtonDict     = nil;
    
    [super dealloc];
}

- (void) LoadData
{
    // combo buttons
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", @"button_a"];
        CCSprite* cSprite   = [CCSprite spriteWithFile:fullStr];
        [comboButtonDict setObject:cSprite forKey:@"button_a"];
    }
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", @"button_b"];
        CCSprite* cSprite   = [CCSprite spriteWithFile:fullStr];
        [comboButtonDict setObject:cSprite forKey:@"button_b"];
    }
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", @"button_c"];
        CCSprite* cSprite   = [CCSprite spriteWithFile:fullStr];
        [comboButtonDict setObject:cSprite forKey:@"button_c"];
    }
    /*
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", @"button_d"];
        CCSprite* cSprite   = [CCSprite spriteWithFile:fullStr];
        [comboButtonDict setObject:cSprite forKey:@"button_d"];
    }
    */
    
    // combos
    NSArray* comboSpriteNameArray    = [[NSArray alloc] initWithObjects:
                                   
                                   @"combo_a",
                                   @"combo_b",
                                   @"combo_c",
                                   //@"combo_d",
                                   
                                   @"combo_a",
                                   @"combo_b",
                                   @"combo_c",
                                   //@"combo_d",
                                   
                                   @"combo_a",
                                   @"combo_b",
                                   @"combo_c",
                                   //@"combo_d",
                                   
                                   @"combo_a",
                                   @"combo_b",
                                   @"combo_c",
                                   //@"combo_d",
                                   
                                   nil];
    
    for (NSString* cSpriteName in comboSpriteNameArray)
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", cSpriteName];
        CCSprite* cSprite   = [CCSprite spriteWithFile:fullStr];
        [comboSpriteArray addObject:cSprite];
    }
    
    [comboSpriteNameArray release];
    comboSpriteNameArray = nil;
    
    // combo arrow
    comboArrowSprite    = [CCSprite spriteWithFile:@"combo_arrow.png"];
    [comboArrowSprite retain];
}

- (void) UnloadData
{
    
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    // combo buttons
    [buttonSpriteArray removeAllObjects];
    
    NSDictionary* resDict   = [ComboPlayer getObject].comboButtonDict;
    for (NSString* cKey in resDict)
    {
        CCSprite* cSprite   = [resDict objectForKey:cKey];
        
        if ( ! hasAddResourcesToLayer )
            [layer addChild:cSprite];
        
        CGPoint buttonCenter    = CGPointMake(110.0f, 60.0f);
        CGFloat spacewidth  = 130.0f;
        CGFloat spaceHeight = 16.0f;
        //CGFloat space03 = 14.0f;
        
        if ( [cKey isEqualToString:@"button_a"] )
        {
            buttonPointArray[0] = CGPointMake(buttonCenter.x - spacewidth * 0.5f,
                                              buttonCenter.y);
            [cSprite setPosition:buttonPointArray[0]];
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else if ( [cKey isEqualToString:@"button_b"] )
        {
            buttonPointArray[1] = CGPointMake(buttonCenter.x,
                                              buttonCenter.y + spaceHeight);
            [cSprite setPosition: buttonPointArray[1]];            
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else if ( [cKey isEqualToString:@"button_c"] )
        {
            buttonPointArray[2] = CGPointMake(buttonCenter.x + spacewidth * 0.5f,
                                              buttonCenter.y);
            [cSprite setPosition: buttonPointArray[2]];
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
//        else if ( [cKey isEqualToString:@"button_d"] )
//        {
//            buttonPointArray[3] = CGPointMake(buttonCenter.x + space01, 
//                                              buttonCenter.y - space03);
//            [cSprite setPosition: buttonPointArray[3]];
//            [buttonSpriteArray addObject:cSprite];
//            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
//        }
        else
        {
            [cSprite setPosition:CGPointMake(buttonCenter.x,
                                             buttonCenter.y)];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        
        [cSprite setOpacity:0];
    }
    
    // combos
    for (CCSprite* cSprite in comboSpriteArray)
    {
        if ( ! hasAddResourcesToLayer )
            [layer addChild:cSprite];
        
        [cSprite setPosition:CGPointMake(0,
                                         0)];
        [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        [cSprite setOpacity:0];
    }
    
    hasAddResourcesToLayer  = YES;
}

- (void) startOverShootEvent
{
    Event* event    = overShootEvent;
    
    // set combo time
    comboTime   = event.comboTime.floatValue;
    
    // init event
    currentComboIndex   = 0;
    
    for (CCSprite* cButton in buttonSpriteArray)
    {
        [cButton setOpacity:255];
    }
    
    [comboNumberArray removeAllObjects];
    
    // random the combo in list
    int comboCount  = 4;
    int randCount   = 3;
    for ( int i=0; i<comboCount; ++i )
    {
        u_int32_t randValue         = arc4random()  % randCount;
        [comboNumberArray addObject:[NSNumber numberWithInt:randValue]];
    }
    
    currentEvent  = event;
}

- (void) startEvent:(Event *)event
{
    // set combo time
    comboTime   = event.comboTime.floatValue;
    
    // init event
    currentComboIndex   = 0;
    
    for (CCSprite* cButton in buttonSpriteArray)
    {
        [cButton setOpacity:255];
    }
    
    [comboNumberArray removeAllObjects];

    // random the combo in list
    int comboCount  = 4;
    int randCount   = 3;
    for ( int i=0; i<comboCount; ++i )
    {
        u_int32_t randValue         = arc4random()  % randCount;
        [comboNumberArray addObject:[NSNumber numberWithInt:randValue]];
    }
    
    currentEvent  = event;
}

- (void) finishEvent:(BOOL)isSuccess
{
    if ( delegate )
    {
        [delegate onEventFinished:currentEvent isSuccess:isSuccess];
    }
    
    // combo buttons
    for (NSString* cKey in comboButtonDict)
    {
        CCSprite* cSprite   = [comboButtonDict objectForKey:cKey];
        [cSprite setOpacity:0];
    }
    
    // combos
    for (CCSprite* cSprite in comboSpriteArray)
    {
        [cSprite setOpacity:0];
    }
    
    // combo arrow
    [comboArrowSprite setOpacity:0];
    
    currentEvent  = nil;
}

- (BOOL) isPlayingEvent
{
    return currentEvent? YES : NO;
}

- (void) Update: (float) deltaTime realTime: (float) realTime
{
    comboTime   -= realTime;
    
    if ( currentEvent )
    {
        CGPoint cComboPos   = comboListPointRef;
    
        [comboArrowSprite setOpacity:255];
        [comboArrowSprite setPosition:CGPointMake(cComboPos.x, cComboPos.y+60.0f)];
        
        for ( int i=currentComboIndex; i<comboNumberArray.count; ++i)
        {
            int cSpriteIndex    = ((NSNumber*)[comboNumberArray objectAtIndex:i]).intValue;
            int cIndex          = cSpriteIndex + (i*3);
            
            CCSprite* cSprite   = [comboSpriteArray objectAtIndex:cIndex];
            [cSprite setOpacity:255];
            [cSprite setPosition:cComboPos];
            
            cComboPos.x += comboListSpace;
        }
    
        // finish event by time
        if ( comboTime <= 0.0f )
        {
            comboTime   = 0.0f;
            [self finishEvent:NO];
        }
    }
    
    if ( comboTime <= 0.0f)
    {
        comboTime   = 0.0f;
    }
}

- (void) touchButtonAtPoint: (CGPoint) point
{

    if ( currentEvent )
    {
        CCSprite* cButtonSprite = [buttonSpriteArray objectAtIndex:0];
        float width     = cButtonSprite.contentSize.width * cButtonSprite.scaleX;
        float height    = cButtonSprite.contentSize.height * cButtonSprite.scaleY;
        
        int touchButtonIndex    = -1;
        for ( int i=0; i<4; ++i)
        {
            CGPoint& cButtonPoint   = buttonPointArray[i];
            if ((cButtonPoint.x - width*0.5) <= point.x && 
                (cButtonPoint.x + width*0.5) >= point.x)
            {
                if ((cButtonPoint.y - height*0.5) <= point.y &&
                    (cButtonPoint.y + height*0.5) >= point.y)
                {
                    touchButtonIndex    = i;
                }
            }
        }
        
        if ( touchButtonIndex != -1 )
        {

            NSNumber* cComboNumber  = [comboNumberArray objectAtIndex:currentComboIndex];
            
            if ( touchButtonIndex == cComboNumber.intValue )
            {
                ++currentComboIndex;
                if ( currentComboIndex >= comboNumberArray.count )
                {
                    [self finishEvent:YES];
                }
                
                for (CCSprite* cSprite in comboSpriteArray)
                {
                    [cSprite setOpacity:0];
                }
            }
            else // press the wrong combo button
            {
                [self finishEvent:NO];
            }
        }
    }
}

@end
