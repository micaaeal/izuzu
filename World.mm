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

#import "Camera.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface WorldCache: NSObject
@property (retain) NSMutableArray*  roadArray;
@property (assign) RouteGraph*      routeGraph;
@property (assign) CGRect           screenBounds;
@property (assign) CCLayer*         layer;
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
    
    // set layer ref
    _worldCache.layer   = layer;
    
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

+ (void) Draw
{
    /*
    Camera* camera      = [Camera getObject];
    CGPoint camPoint    = [camera getPoint];
    CGFloat camZoomX    = [camera getZoomX];
    CGSize camSize  = [[CCDirector sharedDirector] winSize];
    CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                          camPoint.y - camSize.height*0.5f);
    CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                          camCenter.y + camSize.height*0.5f/camZoomX );
    
    CGPoint absPoint        = CGPointMake(camSize.width*0.5f / camZoomX - viewPortPoint.x,
                                          camSize.height*0.5f / camZoomX - viewPortPoint.y );
    
    {
        float centerX   = ( 6477.833496 ) - absPoint.x;
        float centerY   = ( -4512.666992 ) - absPoint.y;
        
        float width     = 100.0f*camZoomX;
        float height    = 100.0f*camZoomX;
        
        {
            CGPoint shipPointArray[4];
            shipPointArray[0].x  = centerX + width;
            shipPointArray[0].y  = centerY + height;
            shipPointArray[1].x  = centerX + width;
            shipPointArray[1].y  = centerY - height;
            shipPointArray[2].x  = centerX - width;
            shipPointArray[2].y  = centerY - height;
            shipPointArray[3].x  = centerX - width;
            shipPointArray[3].y  = centerY + height;
            
            NSUInteger numberOfPoint    = 4;
            ccDrawSolidPoly(shipPointArray, numberOfPoint, ccc4f(0.5, 0.5, 0.5, 1.0));
        }
        {
            centerX += 210.0f*camZoomX;
            
            CGPoint shipPointArray[4];
            shipPointArray[0].x  = centerX + width;
            shipPointArray[0].y  = centerY + height;
            shipPointArray[1].x  = centerX + width;
            shipPointArray[1].y  = centerY - height;
            shipPointArray[2].x  = centerX - width;
            shipPointArray[2].y  = centerY - height;
            shipPointArray[3].x  = centerX - width;
            shipPointArray[3].y  = centerY + height;
            
            NSUInteger numberOfPoint    = 4;
            ccDrawSolidPoly(shipPointArray, numberOfPoint, ccc4f(0.5, 0.7, 0.5, 1.0));
        }
    }
     */
}

@end
