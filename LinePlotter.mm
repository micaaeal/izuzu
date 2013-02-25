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

@interface LinePlotter()

@property (assign) vector<CGPoint>  points;
@property (retain) CCRenderTexture *renderTexture;

@property (assign) float    lineWidth;

- (void) _drawCircleAtPoint: (CGPoint) point;
- (void) _drawLineBetweenPointA: (CGPoint) pa andPointB: (CGPoint) pb;

@end

@implementation LinePlotter

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _renderTexture  = nil;
        
    }
    return self;
}

- (void) dealloc
{
    [_renderTexture release];
    _renderTexture  = nil;
    
    [super dealloc];
}

- (void) start
{
    _points.clear();
    _lineWidth  = 10.0f;
    
    // init render texture
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    _renderTexture = [[CCRenderTexture alloc] initWithWidth:(int)(s.width*0.5)
                                                     height:(int)(s.height*0.5)
                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    _renderTexture.anchorPoint = ccp(0, 0);
    _renderTexture.position = ccp(1024 * 0.5f, 768 * 0.5f);
    [_renderTexture clear:0.0f g:0.0f b:0.0f a:0];
}

- (void) shutdown
{
    _points.clear();
    
}

- (void) clear
{
    _points.clear();
}

- (void) begineWithPoint: (CGPoint) point
{
    [self clear];
    _points.push_back(point);
}

- (void) addPoint: (CGPoint) point
{
    _points.push_back(point);
}

- (void) end
{
    // do nothing
}

- (void) onDraw
{
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
}

- (void) onDrawWithViewport:(CGPoint)vp andCamZoom:(float)zoom
{
    //[_renderTexture begin];
    
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
    
    //[_renderTexture end];
}

- (CGPoint) getLastPoint
{
    return _points.back();
}

#pragma mark - PIMPL

- (void) _drawCircleAtPoint: (CGPoint) point
{
    //ccDrawCircle( point, _lineWidth, 0.0f, 8, YES );
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
}

- (void) _drawLineBetweenPointA: (CGPoint) pa andPointB: (CGPoint) pb
{
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
}

- (CCRenderTexture*) getRenderTexture
{
    return _renderTexture;
}

@end
