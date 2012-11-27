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

#import <vector>
using namespace std;

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface WorldCache: NSObject

@property (retain) NSMutableArray*  roadArray;
@property (assign) RouteGraph*      routeGraph;
@property (assign) CGRect           screenBounds;
@property (assign) CCLayer*         layer;

@property (assign) vector<CGPoint>  floor01;
@property (assign) vector<CGPoint>  floor02;
@property (assign) vector<CGPoint>  floor03;
@property (assign) vector<CGPoint>  floor_grass;

- (void) loadFloor;

- (CGPoint) getFloor01ByNumber: (int) number;
- (int) getFloor01Size;

- (CGPoint) getFloor02ByNumber: (int) number;
- (int) getFloor02Size;

- (CGPoint) getFloor03ByNumber: (int) number;
- (int) getFloor03Size;

- (CGPoint) getFloorGrassByNumber: (int) number;
- (int) getFloorGrassSize;

@end
@implementation WorldCache
@synthesize roadArray;
@synthesize routeGraph;
@synthesize screenBounds;

// floor res
@synthesize floor01;
@synthesize floor02;
@synthesize floor03;
@synthesize floor_grass;

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
        
        [self loadFloor];
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

- (void) loadFloor
{
    // load floor01
    floor01.clear();
    floor01.push_back(CGPointMake(	-	9600	,	330	));
    floor01.push_back(CGPointMake(	-	9179	,	330	));
    floor01.push_back(CGPointMake(	-	9179	,	222	));
    floor01.push_back(CGPointMake(	-	7954	,	75	));
    floor01.push_back(CGPointMake(	-	7954	,	254	));
    floor01.push_back(CGPointMake(	-	6546	,	254	));
    floor01.push_back(CGPointMake(	-	6546	,	75	));
    floor01.push_back(CGPointMake(	-	5900	,	75	));
    floor01.push_back(CGPointMake(	-	5370	,	254	));
    floor01.push_back(CGPointMake(	-	5370	,	400	));
    floor01.push_back(CGPointMake(	-	3024	,	400	));
    floor01.push_back(CGPointMake(	-	3024	,	1000	));
    floor01.push_back(CGPointMake(	-	2610	,	1000	));
    floor01.push_back(CGPointMake(	-	2610	,	1206	));
    floor01.push_back(CGPointMake(	-	1760	,	1206	));
    floor01.push_back(CGPointMake(	-	1760	,	135	));
    floor01.push_back(CGPointMake(	-	1575	,	135	));
    floor01.push_back(CGPointMake(	-	1575	,	1510	));
    floor01.push_back(CGPointMake(	-	1208	,	1510	));
    floor01.push_back(CGPointMake(	-	1208	,	1670	));
    floor01.push_back(CGPointMake(	-	355	,	1670	));
    floor01.push_back(CGPointMake(	-	355	,	1820	));
    floor01.push_back(CGPointMake(	-	1208	,	1820	));
    floor01.push_back(CGPointMake(	-	1208	,	2176	));
    floor01.push_back(CGPointMake(	-	1730	,	2176	));
    floor01.push_back(CGPointMake(	-	1730	,	2865	));
    floor01.push_back(CGPointMake(	-	1417	,	2865	));
    floor01.push_back(CGPointMake(	-	1417	,	4415	));
    floor01.push_back(CGPointMake(	-	1922	,	4415	));
    floor01.push_back(CGPointMake(	-	1922	,	5112	));
    floor01.push_back(CGPointMake(	-	2336	,	5112	));
    floor01.push_back(CGPointMake(	-	2336	,	5576	));
    floor01.push_back(CGPointMake(	-	3460	,	6184	));
    floor01.push_back(CGPointMake(	-	6194	,	6184	));
    floor01.push_back(CGPointMake(	-	6194	,	6330	));
    floor01.push_back(CGPointMake(	-	9600	,	6330	));
    
    floor02.clear();
    floor02.push_back(CGPointMake(	-	9600	,	788	));
    floor02.push_back(CGPointMake(	-	9085	,	788	));
    floor02.push_back(CGPointMake(	-	9085	,	500	));
    floor02.push_back(CGPointMake(	-	8066	,	500	));
    floor02.push_back(CGPointMake(	-	8066	,	728	));
    floor02.push_back(CGPointMake(	-	6442	,	728	));
    floor02.push_back(CGPointMake(	-	6442	,	578	));
    floor02.push_back(CGPointMake(	-	5486	,	578	));
    floor02.push_back(CGPointMake(	-	5486	,	728	));
    floor02.push_back(CGPointMake(	-	3136	,	728	));
    floor02.push_back(CGPointMake(	-	3136	,	1096	));
    floor02.push_back(CGPointMake(	-	2714	,	1096	));
    floor02.push_back(CGPointMake(	-	2714	,	1384	));
    floor02.push_back(CGPointMake(	-	2610	,	1384	));
    floor02.push_back(CGPointMake(	-	2610	,	2086	));
    floor02.push_back(CGPointMake(	-	5186	,	6010	));
    floor02.push_back(CGPointMake(	-	6210	,	6010	));
    floor02.push_back(CGPointMake(	-	6384	,	6133	));
    floor02.push_back(CGPointMake(	-	9600	,	6133	));
    
    floor03.clear();
    floor03.push_back(CGPointMake(	-	9600	,	3300	));
    floor03.push_back(CGPointMake(	-	6720	,	3300	));
    floor03.push_back(CGPointMake(	-	6720	,	3800	));
    floor03.push_back(CGPointMake(	-	5606	,	3800	));
    floor03.push_back(CGPointMake(	-	5606	,	5600	));
    floor03.push_back(CGPointMake(	-	6700	,	5600	));
    floor03.push_back(CGPointMake(	-	6700	,	5912	));
    floor03.push_back(CGPointMake(	-	9600	,	5912	));
    
    floor_grass.clear();
    floor_grass.push_back(CGPointMake(	-	9030	,	3320	));
    floor_grass.push_back(CGPointMake(	-	9030	,	1120	));
    floor_grass.push_back(CGPointMake(	-	5950	,	1120	));
    floor_grass.push_back(CGPointMake(	-	5670	,	1380	));
    floor_grass.push_back(CGPointMake(	-	5400	,	1200	));
    floor_grass.push_back(CGPointMake(	-	3740	,	1200	));
    floor_grass.push_back(CGPointMake(	-	3740	,	728	));
    floor_grass.push_back(CGPointMake(	-	3136	,	728	));
    floor_grass.push_back(CGPointMake(	-	3136	,	1096	));
    floor_grass.push_back(CGPointMake(	-	2714	,	1096	));
    floor_grass.push_back(CGPointMake(	-	2714	,	1384	));
    floor_grass.push_back(CGPointMake(	-	2610	,	1384	));
    floor_grass.push_back(CGPointMake(	-	2610	,	2086	));
    floor_grass.push_back(CGPointMake(	-	2066	,	2086	));
    floor_grass.push_back(CGPointMake(	-	2066	,	2986	));
    floor_grass.push_back(CGPointMake(	-	1550	,	2986	));
    floor_grass.push_back(CGPointMake(	-	1550	,	4274	));
    floor_grass.push_back(CGPointMake(	-	2060	,	4274	));
    floor_grass.push_back(CGPointMake(	-	2060	,	5008	));
    floor_grass.push_back(CGPointMake(	-	2578	,	5008	));
    floor_grass.push_back(CGPointMake(	-	2578	,	5576	));
    floor_grass.push_back(CGPointMake(	-	3460	,	6010	));
    floor_grass.push_back(CGPointMake(	-	5606	,	6010	));
    floor_grass.push_back(CGPointMake(	-	5606	,	5550	));
    floor_grass.push_back(CGPointMake(	-	9030	,	3320	));
}

- (CGPoint) getFloor01ByNumber: (int) number
{
    return floor01[number];
}

- (int) getFloor01Size
{
    return floor01.size();
}

- (CGPoint) getFloor02ByNumber: (int) number
{
    return floor02[number];
}

- (int) getFloor02Size
{
    return floor02.size();
}

- (CGPoint) getFloor03ByNumber: (int) number
{
    return floor03[number];
}

- (int) getFloor03Size
{
    return floor03.size();
}

- (CGPoint) getFloorGrassByNumber: (int) number
{
    return floor_grass[number];
}

- (int) getFloorGrassSize
{
    return floor_grass.size();
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
    Camera* camera      = [Camera getObject];
    CGPoint camPoint    = [camera getPoint];
    CGFloat camZoomX    = [camera getZoomX];
    CGSize camSize  = [[CCDirector sharedDirector] winSize];

    CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                          camPoint.y - camSize.height*0.5f);
    
    CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                          camCenter.y + camSize.height*0.5f/camZoomX );
    
    // water
    vector<CGPoint> waterTran;
    waterTran.push_back(CGPointMake(-20000, 20000));
    waterTran.push_back(CGPointMake(20000, 20000));
    waterTran.push_back(CGPointMake(20000, -20000));
    waterTran.push_back(CGPointMake(-20000, -20000));
    
    // floor01
    vector<CGPoint> floor01Tran;
    for (int i=0; i<[_worldCache getFloor01Size]; ++i)
    {
        CGPoint cPoint  = [_worldCache getFloor01ByNumber:i];
        
        float centerX   = ( viewPortPoint.x - cPoint.x ) * camZoomX;
        float centerY   = ( viewPortPoint.y - cPoint.y ) * camZoomX;
        
        floor01Tran.push_back(CGPointMake(centerX, centerY));
    }
    
    // floor02
    vector<CGPoint> floor02Tran;
    for (int i=0; i<[_worldCache getFloor02Size]; ++i)
    {
        CGPoint cPoint  = [_worldCache getFloor02ByNumber:i];
        
        float centerX   = ( viewPortPoint.x - cPoint.x ) * camZoomX;
        float centerY   = ( viewPortPoint.y - cPoint.y ) * camZoomX;
        
        floor02Tran.push_back(CGPointMake(centerX, centerY));
    }
    
    // floor03
    vector<CGPoint> floor03Tran;
    for (int i=0; i<[_worldCache getFloor03Size]; ++i)
    {
        CGPoint cPoint  = [_worldCache getFloor03ByNumber:i];
        
        float centerX   = ( viewPortPoint.x - cPoint.x ) * camZoomX;
        float centerY   = ( viewPortPoint.y - cPoint.y ) * camZoomX;
        
        floor03Tran.push_back(CGPointMake(centerX, centerY));
    }
    
    // floor_grass
    vector<CGPoint> floorGrassTran;
    for (int i=0; i<[_worldCache getFloorGrassSize]; ++i)
    {
        CGPoint cPoint  = [_worldCache getFloorGrassByNumber:i];
        
        float centerX   = ( viewPortPoint.x - cPoint.x ) * camZoomX;
        float centerY   = ( viewPortPoint.y - cPoint.y ) * camZoomX;
        
        floorGrassTran.push_back(CGPointMake(centerX, centerY));
    }
    
    // draw floor
    //*
    ccDrawSolidPoly(&waterTran.front(),
                    waterTran.size(),
                    ccc4f(22.0f/255.0f,
                          153.0f/255.0f,
                          168.0f/255.0f,
                          1.0));
    ccDrawSolidPoly(&floor01Tran.front(),
                    floor01Tran.size(),
                    ccc4f(195.0f/255.0f,
                          181.0f/255.0f,
                          155.0f/255.0f,
                          1.0));
    ccDrawSolidPoly(&floor02Tran.front(),
                    floor02Tran.size(),
                    ccc4f(149.0f/255.0f,
                          140.0f/255.0f,
                          122.0f/255.0f,
                          1.0));
    ccDrawSolidPoly(&floor03Tran.front(),
                    floor03Tran.size(),
                    ccc4f(196.0f/255.0f,
                          188.0f/255.0f,
                          171.0f/255.0f,
                          1.0));
    ccDrawSolidPoly(&floorGrassTran.front(),
                    floorGrassTran.size(),
                    ccc4f(135.0f/255.0f,
                          156.0f/255.0f,
                          10.0f/255.0f,
                          1.0));
    /*/
    ccDrawPoly(&floor01Tran.front(),
               floor01Tran.size(),
               YES);
    ccDrawPoly(&floor02Tran.front(),
               floor02Tran.size(),
               YES);
    ccDrawPoly(&floor03Tran.front(),
               floor03Tran.size(),
               YES);
    /**/
}

@end
