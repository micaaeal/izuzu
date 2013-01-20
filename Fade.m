//
//  Fade.m
//  DriftForever
//
//  Created by Adawat Chanchua on 1/20/56 BE.
//
//

#import "Fade.h"

Fade* _fadeObject   = nil;

@interface Fade()

@property (retain) CCSprite* fadeSprite;

@end

@implementation Fade

+ (Fade*) getObject
{
    if ( ! _fadeObject )
    {
        _fadeObject = [[Fade alloc] init];
    }
    
    return _fadeObject;
}

- (void) loadData
{
    _fadeSprite  = [CCSprite spriteWithFile:@"black_fade.png"];
    [_fadeSprite setScale:1000.0];
    [_fadeSprite retain];
}

- (void) unloadData
{
    
}

- (void) AssignDataToLayer: (CCLayer*) layer
{
    [layer addChild:_fadeSprite];
}

- (void) blackIt
{
    ccColor3B color = {0, 0, 0};
    [_fadeSprite setColor:color];
    [_fadeSprite setOpacity:255];
}

- (void) fadeOut
{
    [_fadeSprite runAction:[CCFadeOut actionWithDuration:0.5f]];
}

@end
