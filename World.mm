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

@property (assign) vector<CGPoint>  water;
@property (assign) CGPoint*         water_buffer;
@property (assign) vector<CGPoint>  floor01;
@property (assign) CGPoint*         floor01_buffer;
@property (assign) vector<CGPoint>  floor02;
@property (assign) CGPoint*         floor02_buffer;
@property (assign) vector<CGPoint>  floor03;
@property (assign) CGPoint*         floor03_buffer;
@property (assign) vector<CGPoint>  floor_grass;
@property (assign) CGPoint*         floor_grass_buffer;

- (void) loadFloor;

- (vector<CGPoint>) getWater;
- (vector<CGPoint>) getFloor01;
- (vector<CGPoint>) getFloor02;
- (vector<CGPoint>) getFloor03;
- (vector<CGPoint>) getFloorGrass;

- (void) _CreateBufferPoints:(CGPoint**) outBufferPoints fromSourcePointsSize:(long)size;

- (void) _PaintR:(float)r g:(float)g b:(float)b a:(float)a
    sourcePoints:(CGPoint*)sourcePoints
    bufferPoints:(CGPoint*)bufferPoints
            size:(long)size
   viewPortPoint:(CGPoint)viewPortPoint
         camZoom:(float)camZoom;

@end

@implementation WorldCache
@synthesize roadArray;
@synthesize routeGraph;
@synthesize screenBounds;

// floor res
@synthesize water;
@synthesize water_buffer;
@synthesize floor01;
@synthesize floor01_buffer;
@synthesize floor02;
@synthesize floor02_buffer;
@synthesize floor03;
@synthesize floor03_buffer;
@synthesize floor_grass;
@synthesize floor_grass_buffer;

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
    // load water
    water.clear();
    water.push_back(CGPointMake(-20000, 20000));
    water.push_back(CGPointMake(20000, 20000));
    water.push_back(CGPointMake(20000, -20000));
    water.push_back(CGPointMake(-20000, -20000));
    [self _CreateBufferPoints:&water_buffer fromSourcePointsSize:water.size()];
    
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
    [self _CreateBufferPoints:&floor01_buffer fromSourcePointsSize:floor01.size()];
    
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
    [self _CreateBufferPoints:&floor02_buffer fromSourcePointsSize:floor02.size()];
    
    floor03.clear();
    floor03.push_back(CGPointMake(	-	9600	,	3300	));
    floor03.push_back(CGPointMake(	-	6720	,	3300	));
    floor03.push_back(CGPointMake(	-	6720	,	3800	));
    floor03.push_back(CGPointMake(	-	5606	,	3800	));
    floor03.push_back(CGPointMake(	-	5606	,	5600	));
    floor03.push_back(CGPointMake(	-	6700	,	5600	));
    floor03.push_back(CGPointMake(	-	6700	,	5912	));
    floor03.push_back(CGPointMake(	-	9600	,	5912	));
    [self _CreateBufferPoints:&floor03_buffer fromSourcePointsSize:floor03.size()];
    
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
    [self _CreateBufferPoints:&floor_grass_buffer fromSourcePointsSize:floor_grass.size()];
}

- (vector<CGPoint>) getWater
{
    return water;
}

- (vector<CGPoint>) getFloor01
{
    return floor01;
}

- (vector<CGPoint>) getFloor02
{
    return floor02;
}

- (vector<CGPoint>) getFloor03
{
    return floor03;
}

- (vector<CGPoint>) getFloorGrass
{
    return floor_grass;
}

- (void) _CreateBufferPoints:(CGPoint**) outBufferPoints fromSourcePointsSize:(long)size
{
    *outBufferPoints = new CGPoint[size];
    for (int i=0; i<size; ++i)
    {
        (*outBufferPoints)[i]  = CGPointMake(0.0f, 0.0f);
    }
}

- (void) _PaintR:(float)r g:(float)g b:(float)b a:(float)a
    sourcePoints:(CGPoint*)sourcePoints
    bufferPoints:(CGPoint*)bufferPoints
            size:(long)size
   viewPortPoint:(CGPoint)viewPortPoint
         camZoom:(float)camZoom
{
    for (int i=0; i<size; ++i)
    {
        CGPoint cPoint  = sourcePoints[i];
        
        float centerX   = ( viewPortPoint.x - cPoint.x ) * camZoom;
        float centerY   = ( viewPortPoint.y - cPoint.y ) * camZoom;
        
        bufferPoints[i].x   = centerX;
        bufferPoints[i].y   = centerY;
    }
    
    ccDrawSolidPoly(bufferPoints,
                    size,
                    ccc4f(r, g, b, a));
}

@end

World* _s_world = nil;

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface World()

@property (retain) WorldCache* _worldCache;

@end

@implementation World
@synthesize _worldCache;

+ (World*) getObject
{
    if ( ! _s_world )
    {
        _s_world    = [[World alloc] init];
    }
    return _s_world;
}

- (BOOL) LoadData
{
    if ( ! _worldCache )
    {
        _worldCache = [[WorldCache alloc] init];
    }

    // load road config file
    NSString* roadConfigFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"road_config.plist"];
    NSArray* roadConfigArray    = [[NSArray alloc] initWithContentsOfFile:roadConfigFullPath];
    
    // load road to memory
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

- (BOOL) UnloadData
{
    if ( _worldCache )
    {
        [_worldCache release];
        _worldCache = nil;
    }
    
    // @TODO Next
    
    return YES;
}

- (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission
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

- (BOOL) UnSssignDataFromLayer: (CCLayer*) layer
{
    if ( ! _worldCache )
        return NO;
    
    return YES;
}

- (RouteGraph&) GetRouteGraph
{
    return *_worldCache.routeGraph;
}

- (void) Draw
{
    Camera* camera      = [Camera getObject];
    CGPoint camPoint    = [camera getPoint];
    CGFloat camZoomX    = [camera getZoomX];
    CGSize camSize  = [[CCDirector sharedDirector] winSize];

    CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                          camPoint.y - camSize.height*0.5f);
    
    CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                          camCenter.y + camSize.height*0.5f/camZoomX );
    
    [_worldCache _PaintR:22.0f/255.0f
                       g:153.0f/255.0f
                       b:168.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getWater][0]
            bufferPoints:_worldCache.water_buffer
                    size:[_worldCache getWater].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:22.0f/255.0f
                       g:153.0f/255.0f
                       b:168.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor01][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloor01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor01][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloor01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];

    [_worldCache _PaintR:149.0f/255.0f
                       g:149.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor02][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloor02].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:196.0f/255.0f
                       g:188.0f/255.0f
                       b:171.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor03][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloor03].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:135.0f/255.0f
                       g:156.0f/255.0f
                       b:10.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloorGrass][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloorGrass].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
}

@end
