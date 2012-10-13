//
//  World.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import "World.h"
#import "RouteGraph/RouteGraph.h"
#import "Utils.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface WorldCache: NSObject
@property (retain) NSMutableArray*  roadArray;
@property (assign) RouteGraph*      routeGraph;
@property (assign) CGRect           screenBounds;
@end
@implementation WorldCache
@synthesize roadArray;
@synthesize routeGraph;
@synthesize screenBounds;

- (id) init
{
    self    = [super init];
    if (self)
    {
        roadArray   = [[NSMutableArray alloc] init];
        routeGraph  = new RouteGraph;
        routeGraph    = new RouteGraph();
        routeGraph->Start();
        screenBounds  = [[UIScreen mainScreen] bounds];
    }
    return self;
}
- (void) dealloc
{
    screenBounds  = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    routeGraph->Shutdown();
    delete routeGraph;
    routeGraph  = NULL;
    [roadArray release];
    roadArray   = nil;
    [super dealloc];
}
@end

WorldCache* _worldCache = nil;

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation World

+ (BOOL) LoadData
{
    if ( ! _worldCache )
    {
        _worldCache = [[WorldCache alloc] init];
    }

    // load road config file
    NSString* roadConfigFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"road_config.plist"];
    NSArray* roadConfigArray    = [[NSArray alloc] initWithContentsOfFile:roadConfigFullPath];
    
    // load road to memory
    //for (NSDictionary* cRoadDict in roadConfigArray)
    for ( int i=roadConfigArray.count-1; i>=0; --i )
    {
        NSDictionary* cRoadDict = [roadConfigArray objectAtIndex:i];
        
        NSString* file_name = [cRoadDict objectForKey:@"file_name"];
        NSString* x         = [cRoadDict objectForKey:@"x"];
        NSString* y         = [cRoadDict objectForKey:@"y"];
        NSString* rotation  = [cRoadDict objectForKey:@"rotation"];
        
        CCSprite* cSprite   = [CCSprite spriteWithFile:file_name];
        if ( ! cSprite )
        {
            printf ("null image with name: %s", [file_name UTF8String]);
            printf ("\n");
        }
        else
        {
            cSprite.position    = ccp( x.floatValue, y.floatValue );
            [cSprite setRotation:rotation.floatValue];
            [_worldCache.roadArray addObject:cSprite];   
        }
    }
    
    [roadConfigArray release];
    roadConfigArray = nil;
    
    // adjustment
    for (CCSprite* cSprite in _worldCache.roadArray)
    {
        // position
        float actualX   = cSprite.position.x;
        float actualY   = cSprite.position.y;
        CGPoint spritePoint = CGPointMake(actualX, -actualY);
        spritePoint = [UtilVec convertVecIfRetina:spritePoint];
        [cSprite setPosition:spritePoint];
        
        // scale ...
        CGFloat cSpriteScale    = [UtilVec convertScaleIfRetina:cSprite.scale];
        [cSprite setScale:cSpriteScale];
    }
    
    return YES;
}

+ (BOOL) UnloadData
{
    if ( _worldCache )
    {
        [_worldCache release];
        _worldCache = nil;
    }
    
    // @TODO Next
    
    return YES;
}

+ (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission
{
    if ( ! _worldCache )
        return NO;
    
    // road
    for (CCSprite* cSprite in _worldCache.roadArray)
    {
        [layer addChild:cSprite];
    }
    
    return YES;
}

+ (BOOL) UnSssignDataFromLayer: (CCLayer*) layer
{
    if ( ! _worldCache )
        return NO;
    
    return YES;
}

+ (RouteGraph&) GetRouteGraph
{
    return *_worldCache.routeGraph;
}

@end
