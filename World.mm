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
@property (retain) NSMutableArray*  treeArray;
@property (retain) NSMutableArray*  buildingArray;
@property (retain) NSMutableArray*  probArray;
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
@property (assign) vector<CGPoint>  floor04;
@property (assign) CGPoint*         floor04_buffer;
@property (assign) vector<CGPoint>  floor05;
@property (assign) CGPoint*         floor05_buffer;
@property (assign) vector<CGPoint>  floor06;
@property (assign) CGPoint*         floor06_buffer;
@property (assign) vector<CGPoint>  floor07;
@property (assign) CGPoint*         floor07_buffer;

@property (assign) vector<CGPoint>  floor_up01;
@property (assign) CGPoint*         floor_up01_buffer;
@property (assign) vector<CGPoint>  floor_up02;
@property (assign) CGPoint*         floor_up02_buffer;
@property (assign) vector<CGPoint>  floor_up03;
@property (assign) CGPoint*         floor_up03_buffer;

@property (assign) vector<CGPoint>  floor_grass;
@property (assign) CGPoint*         floor_grass_buffer;

@property (assign) vector<CGPoint>  floor_high01;
@property (assign) CGPoint*         floor_high01_buffer;

@property (assign) vector<CGPoint>  floor_etc01;
@property (assign) CGPoint*         floor_etc01_buffer;
@property (assign) vector<CGPoint>  floor_etc02;
@property (assign) CGPoint*         floor_etc02_buffer;
@property (assign) vector<CGPoint>  floor_etc03;
@property (assign) CGPoint*         floor_etc03_buffer;
@property (assign) vector<CGPoint>  floor_etc04;
@property (assign) CGPoint*         floor_etc04_buffer;
@property (assign) vector<CGPoint>  floor_etc05;
@property (assign) CGPoint*         floor_etc05_buffer;

@property (assign) BOOL             isLoadingFloor;

- (void) loadFloor;

- (vector<CGPoint>) getWater;
- (vector<CGPoint>) getFloor01;
- (vector<CGPoint>) getFloor02;
- (vector<CGPoint>) getFloor03;
- (vector<CGPoint>) getFloor04;
- (vector<CGPoint>) getFloor05;
- (vector<CGPoint>) getFloor06;
- (vector<CGPoint>) getFloor07;
- (vector<CGPoint>) getFloor_up01;
- (vector<CGPoint>) getFloor_up02;
- (vector<CGPoint>) getFloor_up03;
- (vector<CGPoint>) getFloorGrass;
- (vector<CGPoint>) getFloor_high01;
- (vector<CGPoint>) getFloor_etc01;
- (vector<CGPoint>) getFloor_etc02;
- (vector<CGPoint>) getFloor_etc03;
- (vector<CGPoint>) getFloor_etc04;
- (vector<CGPoint>) getFloor_etc05;
- (BOOL) getIsLoadingFloor;

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
@synthesize treeArray;
@synthesize buildingArray;
@synthesize probArray;
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
@synthesize floor04;
@synthesize floor04_buffer;
@synthesize floor05;
@synthesize floor05_buffer;
@synthesize floor06;
@synthesize floor06_buffer;
@synthesize floor07;
@synthesize floor07_buffer;

@synthesize floor_up01;
@synthesize floor_up01_buffer;
@synthesize floor_up02;
@synthesize floor_up02_buffer;
@synthesize floor_up03;
@synthesize floor_up03_buffer;

@synthesize floor_grass;
@synthesize floor_grass_buffer;

@synthesize floor_high01;
@synthesize floor_high01_buffer;

@synthesize floor_etc01;
@synthesize floor_etc01_buffer;
@synthesize floor_etc02;
@synthesize floor_etc02_buffer;
@synthesize floor_etc03;
@synthesize floor_etc03_buffer;
@synthesize floor_etc04;
@synthesize floor_etc04_buffer;
@synthesize floor_etc05;
@synthesize floor_etc05_buffer;

@synthesize isLoadingFloor;

- (id) init
{
    self    = [super init];
    if (self)
    {
        roadArray   = [[NSMutableArray alloc] init];
        treeArray   = [[NSMutableArray alloc] init];
        probArray   = [[NSMutableArray alloc] init];
        buildingArray   = [[NSMutableArray alloc] init];
        routeGraph  = new RouteGraph;
        routeGraph    = new RouteGraph();
        routeGraph->Start();
        screenBounds  = [[UIScreen mainScreen] bounds];
        isLoadingFloor  = NO;
        
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
    [buildingArray release];
    buildingArray   = nil;
    [probArray release];
    probArray   = nil;
    [treeArray release];
    treeArray   = nil;
    [roadArray release];
    roadArray   = nil;
    [super dealloc];
}

- (void) loadFloor
{
    isLoadingFloor  = YES;
    
    // load water
    water.clear();
    water.push_back(CGPointMake(-20000, 20000));
    water.push_back(CGPointMake(20000, 20000));
    water.push_back(CGPointMake(20000, -20000));
    water.push_back(CGPointMake(-20000, -20000));
    [self _CreateBufferPoints:&water_buffer fromSourcePointsSize:water.size()];
    
    floor01.clear();
    floor01.push_back(CGPointMake(	-	9600	,	400	));
    floor01.push_back(CGPointMake(	-	3024	,	400	));
    floor01.push_back(CGPointMake(	-	3024	,	1000	));
    floor01.push_back(CGPointMake(	-	2610	,	1000	));
    floor01.push_back(CGPointMake(	-	2610	,	1206	));
    floor01.push_back(CGPointMake(	-	1730	,	1206	));
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
    floor02.push_back(CGPointMake(	-	5372	,	257	));
    floor02.push_back(CGPointMake(	-	9179	,	257	));
    floor02.push_back(CGPointMake(	-	9179	,	800	));
    floor02.push_back(CGPointMake(	-	5372	,	800	));
    [self _CreateBufferPoints:&floor02_buffer fromSourcePointsSize:floor02.size()];
    
    floor03.clear();
    floor03.push_back(CGPointMake(	-	5372	,	260	));
    floor03.push_back(CGPointMake(	-	5834	,	84	));
    floor03.push_back(CGPointMake(	-	6543	,	84	));
    floor03.push_back(CGPointMake(	-	6543	,	260	));
    [self _CreateBufferPoints:&floor03_buffer fromSourcePointsSize:floor03.size()];
    
    floor04.clear();
    floor04.push_back(CGPointMake(	-	7958	,	260	));
    floor04.push_back(CGPointMake(	-	7958	,	84	));
    floor04.push_back(CGPointMake(	-	8714	,	84	));
    floor04.push_back(CGPointMake(	-	9179	,	260	));
    [self _CreateBufferPoints:&floor04_buffer fromSourcePointsSize:floor04.size()];
    
    floor05.clear();
    floor05.push_back(CGPointMake(	-	1215	,	1515	));
    floor05.push_back(CGPointMake(	-	2100	,	1515	));
    floor05.push_back(CGPointMake(	-	2100	,	2169	));
    floor05.push_back(CGPointMake(	-	1215	,	2169	));
    [self _CreateBufferPoints:&floor05_buffer fromSourcePointsSize:floor05.size()];
    
    floor06.clear();
    floor06.push_back(CGPointMake(	-	1584	,	130	));
    floor06.push_back(CGPointMake(	-	1760	,	130	));
    floor06.push_back(CGPointMake(	-	1760	,	1570	));
    floor06.push_back(CGPointMake(	-	1584	,	1570	));
    [self _CreateBufferPoints:&floor06_buffer fromSourcePointsSize:floor06.size()];
    
    floor07.clear();
    floor07.push_back(CGPointMake(	-	360	,	1660	));
    floor07.push_back(CGPointMake(	-	1300	,	1660	));
    floor07.push_back(CGPointMake(	-	1300	,	1823	));
    floor07.push_back(CGPointMake(	-	360	,	1823	));
    [self _CreateBufferPoints:&floor07_buffer fromSourcePointsSize:floor07.size()];
    
    floor_up01.clear();
    floor_up01.push_back(CGPointMake(	-	9600	,	788	));
    floor_up01.push_back(CGPointMake(	-	3136	,	728	));
    floor_up01.push_back(CGPointMake(	-	3136	,	1096	));
    floor_up01.push_back(CGPointMake(	-	2714	,	1096	));
    floor_up01.push_back(CGPointMake(	-	2714	,	1384	));
    floor_up01.push_back(CGPointMake(	-	2610	,	1384	));
    floor_up01.push_back(CGPointMake(	-	2610	,	2086	));
    floor_up01.push_back(CGPointMake(	-	5186	,	6010	));
    floor_up01.push_back(CGPointMake(	-	6210	,	6010	));
    floor_up01.push_back(CGPointMake(	-	6384	,	6133	));
    floor_up01.push_back(CGPointMake(	-	9600	,	6133	));
    [self _CreateBufferPoints:&floor_up01_buffer fromSourcePointsSize:floor_up01.size()];

    floor_up02.clear();
    floor_up02.push_back(CGPointMake(	-	5487	,	576	));
    floor_up02.push_back(CGPointMake(	-	6436	,	576	));
    floor_up02.push_back(CGPointMake(	-	6436	,	800	));
    floor_up02.push_back(CGPointMake(	-	5487	,	800	));
    [self _CreateBufferPoints:&floor_up02_buffer fromSourcePointsSize:floor_up02.size()];
    
    floor_up03.clear();
    floor_up03.push_back(CGPointMake(	-	8067	,	500	));
    floor_up03.push_back(CGPointMake(	-	9080	,	500	));
    floor_up03.push_back(CGPointMake(	-	9080	,	800	));
    floor_up03.push_back(CGPointMake(	-	8067	,	800	));
    [self _CreateBufferPoints:&floor_up03_buffer fromSourcePointsSize:floor_up03.size()];
    
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
    
    floor_high01.clear();
    floor_high01.push_back(CGPointMake(	-	9600	,	3300	));
    floor_high01.push_back(CGPointMake(	-	6720	,	3300	));
    floor_high01.push_back(CGPointMake(	-	6720	,	3800	));
    floor_high01.push_back(CGPointMake(	-	5606	,	3800	));
    floor_high01.push_back(CGPointMake(	-	5606	,	5600	));
    floor_high01.push_back(CGPointMake(	-	6700	,	5600	));
    floor_high01.push_back(CGPointMake(	-	6700	,	5912	));
    floor_high01.push_back(CGPointMake(	-	9600	,	5912	));
    [self _CreateBufferPoints:&floor_high01_buffer fromSourcePointsSize:floor_high01.size()];
    
    floor_etc01.clear();
    floor_etc01.push_back(CGPointMake(	-	5740	,	1760	));
    floor_etc01.push_back(CGPointMake(	-	6720	,	1760	));
    floor_etc01.push_back(CGPointMake(	-	6720	,	2763	));
    floor_etc01.push_back(CGPointMake(	-	5740	,	2763	));
    [self _CreateBufferPoints:&floor_etc01_buffer fromSourcePointsSize:floor_etc01.size()];
    
    floor_etc02.clear();
    floor_etc01.push_back(CGPointMake(	-	5740	,	1760	));
    floor_etc01.push_back(CGPointMake(	-	6720	,	1760	));
    floor_etc01.push_back(CGPointMake(	-	6720	,	2763	));
    floor_etc01.push_back(CGPointMake(	-	5740	,	2763	));
    [self _CreateBufferPoints:&floor_etc02_buffer fromSourcePointsSize:floor_etc02.size()];
    
    floor_etc03.clear();
    floor_etc03.push_back(CGPointMake(	-	2850	,	4026	));
    floor_etc03.push_back(CGPointMake(	-	3880	,	4026	));
    floor_etc03.push_back(CGPointMake(	-	3900	,	5220	));
    floor_etc03.push_back(CGPointMake(	-	2790	,	5220	));
    [self _CreateBufferPoints:&floor_etc03_buffer fromSourcePointsSize:floor_etc03.size()];
    
    floor_etc04.clear();
    floor_etc04.push_back(CGPointMake(	-	3753	,	728	));
    floor_etc04.push_back(CGPointMake(	-	4600	,	728	));
    floor_etc04.push_back(CGPointMake(	-	4600	,	1100	));
    floor_etc04.push_back(CGPointMake(	-	3753	,	1100	));
    [self _CreateBufferPoints:&floor_etc04_buffer fromSourcePointsSize:floor_etc04.size()];

    floor_etc05.clear();
    floor_etc05.push_back(CGPointMake(	-	5606	,	6010	));
    floor_etc05.push_back(CGPointMake(	-	5606	,	5600	));
    floor_etc05.push_back(CGPointMake(	-	6100	,	5600	));
    floor_etc05.push_back(CGPointMake(	-	6100	,	6010	));
    [self _CreateBufferPoints:&floor_etc05_buffer fromSourcePointsSize:floor_etc05.size()];
    
    isLoadingFloor  = NO;
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

- (vector<CGPoint>) getFloor04
{
    return floor04;
}

- (vector<CGPoint>) getFloor05
{
    return floor05;
}

- (vector<CGPoint>) getFloor06
{
    return floor06;
}

- (vector<CGPoint>) getFloor07
{
    return floor07;
}

- (vector<CGPoint>) getFloor_up01
{
    return floor_up01;
}

- (vector<CGPoint>) getFloor_up02
{
    return floor_up02;
}

- (vector<CGPoint>) getFloor_up03
{
    return floor_up03;
}

- (vector<CGPoint>) getFloorGrass
{
    return floor_grass;
}

- (vector<CGPoint>) getFloor_high01
{
    return floor_high01;
}

- (vector<CGPoint>) getFloor_etc01
{
    return floor_etc01;
}

- (vector<CGPoint>) getFloor_etc02
{
    return floor_etc02;
}

- (vector<CGPoint>) getFloor_etc03
{
    return floor_etc03;
}

- (vector<CGPoint>) getFloor_etc04
{
    return floor_etc04;
}

- (vector<CGPoint>) getFloor_etc05
{
    return floor_etc05;
}

- (BOOL) getIsLoadingFloor
{
    return isLoadingFloor;
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

    // ----------------------------------------------------------------
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
    
    // ----------------------------------------------------------------
    // load trees
    CGPoint treePoints[]    = {
        CGPointMake(	3036	,	-	548	),
        CGPointMake(	3448	,	-	670	),
        CGPointMake(	4791	,	-	1239	),
        CGPointMake(	6904	,	-	1060	),
        CGPointMake(	6724	,	-	1321	),
        CGPointMake(	7663	,	-	1008	),
        CGPointMake(	8209	,	-	1159	),
        CGPointMake(	2457	,	-	2870	),
        CGPointMake(	3319	,	-	3572	),
        CGPointMake(	3502	,	-	1654	),
        CGPointMake(	3757	,	-	2339	),
        CGPointMake(	3124	,	-	3569	),
        CGPointMake(	3728	,	-	3167	),
        CGPointMake(	4384	,	-	3271	),
        CGPointMake(	4204	,	-	3671	),
        CGPointMake(	4819	,	-	3404	),
        CGPointMake(	4807	,	-	3920	),
        CGPointMake(	4337	,	-	4257	),
        CGPointMake(	4326	,	-	5619	),
        CGPointMake(	4767	,	-	5596	),
        CGPointMake(	4519	,	-	2001	),
        CGPointMake(	5069	,	-	1792	),
        CGPointMake(	5340	,	-	2622	),
        CGPointMake(	5685	,	-	3204	),
        CGPointMake(	7279	,	-	2396	),
        CGPointMake(	7630	,	-	2143	),
        CGPointMake(	8227	,	-	1946	),
        CGPointMake(	8641	,	-	2543	),
        CGPointMake(	8555	,	-	2684	)
    };
    int treePointsCount     = 29;
    for ( int i=0; i<treePointsCount; ++i )
    {
        CGPoint treePoint       = treePoints[i];
        treePoint.x += 50.0f;
        treePoint.y -= 200.0f;
        treePoint               = [UtilVec convertVecIfRetina:treePoint];
        CCSprite* treeSprite    = [CCSprite spriteWithFile:@"tree.png"];
        [_worldCache.treeArray addObject:treeSprite];
        [treeSprite setPosition:treePoint];
    }
    
    // ----------------------------------------------------------------
    // load buildings
    CGPoint buildingOffset  = CGPointMake(-135, 0.0f);
    {
        CGPoint buildingPoint  = CGPointMake(5838.0f, -4817.0f);
        buildingPoint.x += buildingOffset.x;
        buildingPoint.y += buildingOffset.y;
        buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
        CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build01.png"];
        [_worldCache.buildingArray addObject:buildingSprite];
        buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
        buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
        [buildingSprite setPosition:buildingPoint];
    }
    {
        CGPoint buildingPoint  = CGPointMake(6721.0f, -5052.0f);
        buildingPoint.x += buildingOffset.x;
        buildingPoint.y += buildingOffset.y;
        buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
        CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build02.png"];
        [_worldCache.buildingArray addObject:buildingSprite];
        buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
        buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
        [buildingSprite setPosition:buildingPoint];
    }
    {
        CGPoint buildingPoint  = CGPointMake(8077.0f, -4846.0f);
        buildingPoint.x += buildingOffset.x;
        buildingPoint.y += buildingOffset.y;
        buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
        CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build03.png"];
        [_worldCache.buildingArray addObject:buildingSprite];
        buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
        buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
        [buildingSprite setPosition:buildingPoint];
    }
    {
        CGPoint buildingPoint  = CGPointMake(7928.0f, -4172.0f);
        buildingPoint.x += buildingOffset.x;
        buildingPoint.y += buildingOffset.y;
        buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
        CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build04.png"];
        [_worldCache.buildingArray addObject:buildingSprite];
        buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
        buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
        [buildingSprite setPosition:buildingPoint];
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	5871	,	-3943	));
        points.push_back(CGPointMake(	6129	,	-3943	));
        points.push_back(CGPointMake(	6391	,	-3943	));
        points.push_back(CGPointMake(	6638	,	-3943	));
        points.push_back(CGPointMake(	5871	,	-4229	));
        points.push_back(CGPointMake(	6129	,	-4229	));
        points.push_back(CGPointMake(	6391	,	-4229	));
        points.push_back(CGPointMake(	6638	,	-4229	));
        points.push_back(CGPointMake(	5871	,	-4405	));
        points.push_back(CGPointMake(	6129	,	-4405	));
        points.push_back(CGPointMake(	6391	,	-4405	));
        points.push_back(CGPointMake(	6638	,	-4405	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build05.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	6836	,	-3433	));
        points.push_back(CGPointMake(	8010	,	-3433	));
        points.push_back(CGPointMake(	8827	,	-3433	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build06.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	9354	,	-2460	));
        points.push_back(CGPointMake(	9354	,	-1694	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build07.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	8835	,	-1094	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build08.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	5838	,	-1328	));
        points.push_back(CGPointMake(	2926	,	-1397	));
        points.push_back(CGPointMake(	4243	,	-4817	));
        points.push_back(CGPointMake(	7254	,	-4793	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build09.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	7126	,	-2738	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build10.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	7329	,	-4405	));
        points.push_back(CGPointMake(	7785	,	-1285	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build11.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	2474	,	-2297	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build12.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	3932	,	-874	));
        points.push_back(CGPointMake(	4251	,	-874	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build13.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	8156	,	-2231	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build14.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	4285	,	-2751	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build15.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	2575	,	-3811	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build16.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	5731	,	-1784	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"build17.png"];
            [_worldCache.buildingArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    
    // ----------------------------------------------------------------
    // load prop
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	4526	,	-	969	));
        points.push_back(CGPointMake(	6116	,	-	846	));
        points.push_back(CGPointMake(	9044	,	-	846	));
        points.push_back(CGPointMake(	4259	,	-	5018	));
        points.push_back(CGPointMake(	7697	,	-	3597	));
        points.push_back(CGPointMake(	7394	,	-	5429	));
        points.push_back(CGPointMake(	8420	,	-	5429	));
        points.push_back(CGPointMake(	8930	,	-	4551	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob01.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	3711	,	-	939	));
        points.push_back(CGPointMake(	5261	,	-	3556	));
        points.push_back(CGPointMake(	7801	,	-	2979	));
        points.push_back(CGPointMake(	7537	,	-	3546	));
        points.push_back(CGPointMake(	6719	,	-	4804	));
        points.push_back(CGPointMake(	9353	,	-	5378	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob02.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    // prob03 is ommited
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	6408	,	-	1169	));
        points.push_back(CGPointMake(	4250	,	-	4559	));
        points.push_back(CGPointMake(	4584	,	-	4559	));
        points.push_back(CGPointMake(	4948	,	-	4559	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob04.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	2943	,	-	2003	));
        points.push_back(CGPointMake(	2627	,	-	3188	));
        points.push_back(CGPointMake(	3940	,	-	2889	));
        points.push_back(CGPointMake(	5103	,	-	2423	));
        points.push_back(CGPointMake(	5402	,	-	1792	));
        points.push_back(CGPointMake(	5518	,	-	3204	));
        points.push_back(CGPointMake(	5618	,	-	3541	));
        points.push_back(CGPointMake(	6504	,	-	1155	));
        points.push_back(CGPointMake(	6859	,	-	1986	));
        points.push_back(CGPointMake(	7142	,	-	2445	));
        points.push_back(CGPointMake(	6727	,	-	2888	));
        points.push_back(CGPointMake(	7514	,	-	2977	));
        points.push_back(CGPointMake(	8129	,	-	1676	));
        points.push_back(CGPointMake(	8556	,	-	1676	));
        points.push_back(CGPointMake(	8218	,	-	2900	));
        points.push_back(CGPointMake(	4572	,	-	4013	));
        points.push_back(CGPointMake(	3929	,	-	5403	));
        points.push_back(CGPointMake(	4849	,	-	4526	));
        points.push_back(CGPointMake(	5365	,	-	4080	));
        points.push_back(CGPointMake(	5365	,	-	4554	));
        points.push_back(CGPointMake(	5365	,	-	4949	));
        points.push_back(CGPointMake(	5365	,	-	5265	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob05.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	3505	,	-	2618	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob06.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	3234	,	-	737	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"prob07.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    // prob08 is ommited
    // prob09 is ommited
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	9156	,	-	4339	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"rail.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	2967	,	-	3245	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"targetA.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	8754	,	-	1727	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"targetB.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	9006	,	-	5288	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"targetC.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	3930	,	-	1250	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"targetD.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	6897	,	-	2123	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"targetE.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	7991	,	-	3921	));
        points.push_back(CGPointMake(	8127	,	-	3921	));
        points.push_back(CGPointMake(	8271	,	-	3921	));
        points.push_back(CGPointMake(	8420	,	-	3921	));
        points.push_back(CGPointMake(	8567	,	-	3921	));
        points.push_back(CGPointMake(	8710	,	-	3921	));
        points.push_back(CGPointMake(	7991	,	-	4070	));
        points.push_back(CGPointMake(	8127	,	-	4070	));
        points.push_back(CGPointMake(	8271	,	-	4070	));
        points.push_back(CGPointMake(	8420	,	-	4070	));
        points.push_back(CGPointMake(	8567	,	-	4070	));
        points.push_back(CGPointMake(	8710	,	-	4070	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"tent01.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	7354	,	-	3938	));
        points.push_back(CGPointMake(	7354	,	-	4083	));
        points.push_back(CGPointMake(	7354	,	-	4232	));
        points.push_back(CGPointMake(	7490	,	-	3938	));
        points.push_back(CGPointMake(	7490	,	-	4083	));
        points.push_back(CGPointMake(	7490	,	-	4232	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"tent02.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
    }
    {
        vector<CGPoint> points;
        points.push_back(CGPointMake(	7411	,	-	5052	));
        points.push_back(CGPointMake(	7411	,	-	5189	));
        points.push_back(CGPointMake(	7411	,	-	5335	));
        points.push_back(CGPointMake(	7536	,	-	5052	));
        points.push_back(CGPointMake(	7536	,	-	5189	));
        points.push_back(CGPointMake(	7536	,	-	5335	));
        for (int i=0; i<points.size(); ++i)
        {
            CGPoint buildingPoint  = points[i];
            buildingPoint.x += buildingOffset.x;
            buildingPoint.y += buildingOffset.y;
            buildingPoint               = [UtilVec convertVecIfRetina:buildingPoint];
            CCSprite* buildingSprite    = [CCSprite spriteWithFile:@"tent03.png"];
            [_worldCache.probArray addObject:buildingSprite];
            buildingPoint.x += buildingSprite.textureRect.size.width*0.5f;
            buildingPoint.y -= buildingSprite.textureRect.size.height*0.5f;
            [buildingSprite setPosition:buildingPoint];
        }
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
    for ( CCSprite* cSprite in _worldCache.roadArray )
    {
        [layer addChild:cSprite];
    }
    
    // trees
    for ( CCSprite* cSprite in _worldCache.treeArray )
    {
        [layer addChild:cSprite];
    }
    
    // buildings
    for ( CCSprite* cSprite in _worldCache.buildingArray )
    {
        [layer addChild:cSprite];
    }
    
    // prob
    for ( CCSprite* cSprite in _worldCache.probArray )
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
    if ( _worldCache.isLoadingFloor )
        return;
    
    Camera* camera      = [Camera getObject];
    CGPoint camPoint    = [camera getPoint];
    CGFloat camZoomX    = [camera getZoomX];
    CGSize camSize  = [[CCDirector sharedDirector] winSize];

    CGPoint camCenter       = CGPointMake((camPoint.x-125.0f) - camSize.width*0.5f,
                                          camPoint.y - camSize.height*0.5f);
    
    CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                          camCenter.y + camSize.height*0.5f/camZoomX );
    
    // water
    [_worldCache _PaintR:22.0f/255.0f
                       g:153.0f/255.0f
                       b:168.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getWater][0]
            bufferPoints:_worldCache.water_buffer
                    size:[_worldCache getWater].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    // floor
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor01][0]
            bufferPoints:_worldCache.floor01_buffer
                    size:[_worldCache getFloor01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];

    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor02][0]
            bufferPoints:_worldCache.floor02_buffer
                    size:[_worldCache getFloor02].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor03][0]
            bufferPoints:_worldCache.floor03_buffer
                    size:[_worldCache getFloor03].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor04][0]
            bufferPoints:_worldCache.floor04_buffer
                    size:[_worldCache getFloor04].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor05][0]
            bufferPoints:_worldCache.floor05_buffer
                    size:[_worldCache getFloor05].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor06][0]
            bufferPoints:_worldCache.floor06_buffer
                    size:[_worldCache getFloor06].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:195.0f/255.0f
                       g:181.0f/255.0f
                       b:155.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor07][0]
            bufferPoints:_worldCache.floor07_buffer
                    size:[_worldCache getFloor07].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    // floor up
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_up01][0]
            bufferPoints:_worldCache.floor_up01_buffer
                    size:[_worldCache getFloor_up01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_up02][0]
            bufferPoints:_worldCache.floor_up02_buffer
                    size:[_worldCache getFloor_up02].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_up03][0]
            bufferPoints:_worldCache.floor_up03_buffer
                    size:[_worldCache getFloor_up03].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    // grass
    [_worldCache _PaintR:135.0f/255.0f
                       g:156.0f/255.0f
                       b:10.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloorGrass][0]
            bufferPoints:_worldCache.floor_grass_buffer
                    size:[_worldCache getFloorGrass].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    // floor high
    [_worldCache _PaintR:196.0f/255.0f
                       g:188.0f/255.0f
                       b:171.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_high01][0]
            bufferPoints:_worldCache.floor_high01_buffer
                    size:[_worldCache getFloor_high01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
    // floor etc
    [_worldCache _PaintR:196.0f/255.0f
                       g:188.0f/255.0f
                       b:171.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_etc01][0]
            bufferPoints:_worldCache.floor_etc01_buffer
                    size:[_worldCache getFloor_etc01].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    [_worldCache _PaintR:196.0f/255.0f
                       g:188.0f/255.0f
                       b:171.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_etc02][0]
            bufferPoints:_worldCache.floor_etc02_buffer
                    size:[_worldCache getFloor_etc02].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_etc03][0]
            bufferPoints:_worldCache.floor_etc03_buffer
                    size:[_worldCache getFloor_etc03].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_etc04][0]
            bufferPoints:_worldCache.floor_etc04_buffer
                    size:[_worldCache getFloor_etc04].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    [_worldCache _PaintR:149.0f/255.0f
                       g:140.0f/255.0f
                       b:122.0f/255.0f
                       a:1.0
            sourcePoints:&[_worldCache getFloor_etc05][0]
            bufferPoints:_worldCache.floor_etc05_buffer
                    size:[_worldCache getFloor_etc05].size()
           viewPortPoint:viewPortPoint camZoom:camZoomX];
    
}

@end
