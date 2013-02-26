//
//  LinePlotter.m
//  PathPlotter
//
//  Created by Adawat Chanchua on 2/25/56 BE.
//
//

#import "LinePlotter.h"
#import <vector>
using namespace std;
#import "cocos2d.h"
#import "UtilVec.h"

@interface LinePlotter()

@property (assign) vector<CGPoint>  points;
@property (assign) float            lineWidth;
@property (assign) CCLayer*         _rootLayer;

@property (retain) NSMutableArray*  pointTextures;
@property (retain) NSMutableArray*  pathTextures;

- (void) _drawCircleAtPoint: (CGPoint) point;
- (void) _drawLineBetweenPointA: (CGPoint) pa andPointB: (CGPoint) pb;

@end

@implementation LinePlotter
@synthesize _rootLayer;

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _rootLayer  = nil;
        _pointTextures  = [[NSMutableArray alloc] init];
        _pathTextures   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_pathTextures release];
    [_pointTextures release];
    [super dealloc];
}

- (void) start
{
    _points.clear();
    _lineWidth  = 10.0f;
    
}

- (void) shutdown
{
    _points.clear();
    
}

- (void) clear
{
    _points.clear();
    
    for ( int i=0; i<_pointTextures.count; ++i )
    {
        CCSprite* cSprite   = [_pointTextures objectAtIndex:i];
        [cSprite removeFromParentAndCleanup:YES];
    }
    
    [_pointTextures removeAllObjects];
    
    for ( int i=0; i<_pathTextures.count; ++i )
    {
        CCSprite* cSprite   = [_pathTextures objectAtIndex:i];
        [cSprite removeFromParentAndCleanup:YES];
    }
    
    [_pathTextures removeAllObjects];
}

- (void) begineWithPoint: (CGPoint) point
{
    [self clear];
    _points.push_back(point);
    //[self _drawCircleAtPoint:point];
}

- (void) addPoint: (CGPoint) point
{
    BOOL hasLastPoint   = NO;
    CGPoint lastPoint   = CGPointMake(0, 0);
    if ( _points.size() > 0 )
    {
        lastPoint       = _points.back();
        hasLastPoint    = YES;
    }
    
    _points.push_back(point);
    [self _drawCircleAtPoint:point];
    
    if ( ! hasLastPoint )
        return;
    
    [self _drawLineBetweenPointA:lastPoint andPointB:point];
}

- (void) end
{
    // do nothing
}

- (void) onDraw
{
    /*
    BOOL hasPrevPoint   = NO;
    CGPoint prevPoint;
    
    for ( int i=0; i<_points.size(); ++i )
    {
        CGPoint cPoint  = _points[i];
        
        // draw circle
        [self _drawCircleAtPoint:cPoint];
        
        if ( hasPrevPoint == YES )
        {
            [self _drawLineBetweenPointA:prevPoint andPointB:cPoint];
        }
        
        prevPoint   = cPoint;
        hasPrevPoint    = YES;
    }
    */
}

- (void) onDrawWithViewport:(CGPoint)vp andCamZoom:(float)zoom
{
    /*
    BOOL hasPrevPoint   = NO;
    CGPoint prevPoint;
    
    for ( int i=0; i<_points.size(); ++i )
    {
        CGPoint cPoint  = _points[i];
     
        float centerX   = ( vp.x - cPoint.x ) * zoom;
        float centerY   = ( vp.y - cPoint.y ) * zoom;
        CGPoint center  = CGPointMake(centerX, centerY);
        
        // draw circle
        [self _drawCircleAtPoint:center];
        
        if ( hasPrevPoint == YES )
        {
            [self _drawLineBetweenPointA:prevPoint andPointB:center];
        }
        
        prevPoint   = center;
        hasPrevPoint    = YES;
    }
    */
}

- (CGPoint) getLastPoint
{
    return _points.back();
}

#pragma mark - PIMPL

- (void) _drawCircleAtPoint: (CGPoint) point
{
    /*
    CGPoint center      = point;
    int verticesCount   = 10;
    float radius        = _lineWidth * 0.5f;
    
    float angleEachVertex   = 360.0f / verticesCount;
    float radianEachVertex  = angleEachVertex * M_PI / 180.0f;
    
    float cRadian   = 0.0f;
    
    vector<CGPoint> points;
    points.push_back(center);
    
    float pi_pi = M_PI * 2.0f;
    while ( cRadian <= pi_pi + radianEachVertex )
    {
        float x = ( cos(cRadian) * radius ) + center.x;
        float y = ( sin(cRadian) * radius ) + center.y;
        
        points.push_back(CGPointMake(x, y));
        
        cRadian += radianEachVertex;
    }
    
    ccDrawSolidPoly(&points[0],
                    points.size(),
                    ccc4f(1.0f, 1.0f, 1.0f, 1.0f));
    /*/
    CCSprite* circleSprite  = [CCSprite spriteWithFile:@"selector_ball.png"];
    CGFloat cSpriteScale    = [UtilVec convertScaleIfRetina:circleSprite.scale];
    [circleSprite setScale:cSpriteScale];
    [circleSprite setPosition:point];
    [_rootLayer addChild:circleSprite];
    [_pointTextures addObject:circleSprite];
    /**/
}

- (void) _drawLineBetweenPointA: (CGPoint) pa andPointB: (CGPoint) pb
{
    /*
    CGPoint dir = ccpSub(pb, pa);
    CGPoint perpendicular = ccpNormalize(ccpPerp(dir));
    
    CGPoint cRect[4];
    cRect[0]    = ccpAdd(pa, ccpMult(perpendicular, _lineWidth / 2));
    cRect[1]    = ccpSub(pa, ccpMult(perpendicular, _lineWidth / 2));
    cRect[3]    = ccpAdd(pb, ccpMult(perpendicular, _lineWidth / 2));
    cRect[2]    = ccpSub(pb, ccpMult(perpendicular, _lineWidth / 2));
    
    ccDrawSolidPoly(cRect,
                    4,
                    ccc4f(1.0f, 1.0f, 1.0f, 1.0f));
    /*/
    CCSprite* lightSprite  = [CCSprite spriteWithFile:@"light.png"];
    CGFloat cSpriteScale    = [UtilVec convertScaleIfRetina:lightSprite.scale];
    [lightSprite setScale:cSpriteScale];
    [lightSprite setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    [lightSprite setPosition:pa];
    [_rootLayer addChild:lightSprite];
    [_pathTextures addObject:lightSprite];
    
    // set position
    CGPoint from    = pa;
    CGPoint to      = pb;
    lightSprite.position = from;
    
    // rotation
    float difX      = to.x - from.x;
    float difY      = to.y - from.y;
    float radian    = atan2f(difX, difY);
    
    lightSprite.rotation = radian * 180.0f / M_PI;
    
    // scale
    float length        = sqrtf( difX*difX + difY*difY );
    
    float lightScaleY   = ( length / lightSprite.textureRect.size.height );
    
    [lightSprite setScaleY:lightScaleY];
    /**/
}

- (void) setRootLayer: (CCLayer*) rootLayer
{
    _rootLayer  = rootLayer;
}

@end
