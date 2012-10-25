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
CGPoint buttonPointArray[4];

@interface ComboPlayer()

@property (retain) NSMutableDictionary* resourceDict;

// combo list
@property (assign) CGPoint  comboListPointRef;
@property (assign) float    comboListSpace;
@property (assign) int      currentComboIndex;
@property (retain) Combo*   currentCombo;

@property (retain) NSMutableArray*  buttonSpriteArray;
@property (retain) NSMutableArray*  comboSpriteArray;
@property (retain) NSMutableArray*  comboNumberArray;
@property (retain) CCSprite*    comboArrowSprite;

@end

@implementation ComboPlayer
@synthesize resourceDict;
@synthesize comboListPointRef;
@synthesize comboListSpace;
@synthesize currentComboIndex;
@synthesize currentCombo;
@synthesize buttonSpriteArray;
@synthesize comboSpriteArray;
@synthesize comboNumberArray;
@synthesize comboArrowSprite;
@synthesize delegate;

+ (ComboPlayer*) getObject
{
    if ( ! _s_object )
    {
        _s_object   = [[ComboPlayer alloc] init];
        _s_object.resourceDict      = [[NSMutableDictionary alloc] init];
        
        CGSize winSize          = [CCDirector sharedDirector].winSize;
        
        if ( winSize.width < 481.0f ) // iPhone win size
        {
            _s_object.comboListPointRef = CGPointMake(120.0f, 250.0f);
        }
        else
        {
            _s_object.comboListPointRef = CGPointMake(400.0f, 600.0f);
        }
        
        _s_object.comboListSpace    = 70.0f;
        _s_object.currentComboIndex = 0;
        _s_object.currentCombo      = nil;
        _s_object.comboSpriteArray  = [[NSMutableArray alloc] init];
        _s_object.comboNumberArray  = [[NSMutableArray alloc] init];
        _s_object.buttonSpriteArray = [[NSMutableArray alloc] init];
        _s_object.delegate          = nil;
    }
    
    return _s_object;
}

- (void) LoadData
{
    NSArray* spriteNameArray    = [[NSArray alloc] initWithObjects:
                                   @"button_a",
                                   @"button_b",
                                   @"button_c",
                                   @"button_d",
                                   @"combo_a",
                                   @"combo_b",
                                   @"combo_c",
                                   @"combo_d",
                                   @"combo_arrow",
                                   nil];
    
    for (NSString* cSpriteName in spriteNameArray)
    {
        NSString* fullStr   = [NSString stringWithFormat:@"%@.png", cSpriteName];
        CCSprite* sprite    = [CCSprite spriteWithFile:fullStr];
        [[ComboPlayer getObject].resourceDict setObject:sprite forKey:cSpriteName];
    }
    
    // combo image
    [comboSpriteArray addObject:[resourceDict objectForKey:@"combo_a"]];
    [comboSpriteArray addObject:[resourceDict objectForKey:@"combo_b"]];
    [comboSpriteArray addObject:[resourceDict objectForKey:@"combo_c"]];
    [comboSpriteArray addObject:[resourceDict objectForKey:@"combo_d"]];
    
    // combo arrow
    comboArrowSprite    = [resourceDict objectForKey:@"combo_arrow"];
    
    [spriteNameArray release];
    spriteNameArray = nil;
}

- (void) UnloadData
{
    
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    [buttonSpriteArray removeAllObjects];
    
    NSDictionary* resDict   = [ComboPlayer getObject].resourceDict;
    for (NSString* cKey in resDict)
    {
        CCSprite* cSprite   = [resDict objectForKey:cKey];
        [layer addChild:cSprite];
        
        CGPoint buttonCenter    = CGPointMake(90.0f, 90.0f);
        CGFloat space01 = 50.0f;
        CGFloat space02 = 10.0f;
        CGFloat space03 = 12.0f;
        
        if ( [cKey isEqualToString:@"button_a"] )
        {
            buttonPointArray[0] = CGPointMake(buttonCenter.x - space01, 
                                              buttonCenter.y + space03); 
            [cSprite setPosition:buttonPointArray[0]];    
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else if ( [cKey isEqualToString:@"button_b"] )
        {
            buttonPointArray[1] = CGPointMake(buttonCenter.x - space02, 
                                              buttonCenter.y - space01); 
            [cSprite setPosition: buttonPointArray[1]];            
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else if ( [cKey isEqualToString:@"button_c"] )
        {
            buttonPointArray[2] = CGPointMake(buttonCenter.x + space02, 
                                              buttonCenter.y + space01);
            [cSprite setPosition: buttonPointArray[2]];
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else if ( [cKey isEqualToString:@"button_d"] )
        {
            buttonPointArray[3] = CGPointMake(buttonCenter.x + space01, 
                                              buttonCenter.y - space03);
            [cSprite setPosition: buttonPointArray[3]];
            [buttonSpriteArray addObject:cSprite];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        else
        {
            [cSprite setPosition:CGPointMake(buttonCenter.x,
                                             buttonCenter.y)];
            [cSprite setScale:[UtilVec convertScaleIfRetina:cSprite.scale]];
        }
        
        [cSprite setOpacity:0];
    }
}

- (void) startCombo: (Combo*) combo
{
    currentComboIndex   = 0;
    
    for (CCSprite* cButton in buttonSpriteArray)
    {
        [cButton setOpacity:255];
    }
    
    [comboNumberArray removeAllObjects];
    for (NSString* cComboStr in combo.comboList)
    {
        if ( [cComboStr.uppercaseString isEqualToString:@"A"] )
        {
            [comboNumberArray addObject:[NSNumber numberWithInt:0]];
        }
        else if ( [cComboStr.uppercaseString isEqualToString:@"B"] )
        {
            [comboNumberArray addObject:[NSNumber numberWithInt:1]];
        }
        else if ( [cComboStr.uppercaseString isEqualToString:@"C"] )
        {
            [comboNumberArray addObject:[NSNumber numberWithInt:2]];
        }
        else if ( [cComboStr.uppercaseString isEqualToString:@"D"] )
        {
            [comboNumberArray addObject:[NSNumber numberWithInt:3]];
        }
        else {
            // do nothing
        }
    }
    
    currentCombo  = combo;
}

- (void) finishCombo: (BOOL) isSuccess
{
    if ( delegate )
    {
        [delegate onComboFinished:currentCombo isSuccess:isSuccess];
    }
    
    for (NSString* cKey in resourceDict)
    {
        CCSprite* cSprite   = [resourceDict objectForKey:cKey];
        [cSprite setOpacity:0];
    }
    
    currentCombo  = nil;
}

- (BOOL) isPlayingCombo
{
    return currentCombo? YES : NO;
}

- (void) Update: (float) deltaTime
{
    if ( currentCombo )
    {
        CGPoint cComboPos   = comboListPointRef;
    
        [comboArrowSprite setOpacity:255];
        [comboArrowSprite setPosition:CGPointMake(cComboPos.x, cComboPos.y+60.0f)];
        
        for ( int i=currentComboIndex; i<comboNumberArray.count; ++i)
        {
            int cSpriteIndex    = ((NSNumber*)[comboNumberArray objectAtIndex:i]).intValue;
            
            CCSprite* cSprite   = [comboSpriteArray objectAtIndex:cSpriteIndex];
            [cSprite setOpacity:255];
            [cSprite setPosition:cComboPos];
            
            cComboPos.x += comboListSpace;
        }
    }
}

- (void) touchButtonAtPoint: (CGPoint) point
{
//    printf ("touching button AT point: (%f,%f)", point.x, point.y);
//    printf ("\n");
    if ( currentCombo )
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
//            printf ("touch button at index: %d", touchButtonIndex);
//            printf ("\n");
            
            NSNumber* cComboNumber  = [comboNumberArray objectAtIndex:currentComboIndex];
            
            if ( touchButtonIndex == cComboNumber.intValue )
            {
//                printf ("correct combo!");
//                printf ("\n");
                ++currentComboIndex;
                if ( currentComboIndex >= comboNumberArray.count )
                {
//                    printf ("finish combo!");
                    [self finishCombo:YES];
                }
                
                for (CCSprite* cSprite in comboSpriteArray)
                {
                    [cSprite setOpacity:0];
                }
            }
            else
            {
//                printf ("wrong combo!");
//                printf ("\n");
            }
        }
    }
}

@end
