//
//  Camera.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import "Camera.h"

Camera* _object = nil;

@interface Camera()

@property (assign) CCLayer*     _layer;
@property (assign) BOOL         _isZooming;
@property (assign) CGPoint      _layerRefPoint;
@property (assign) CGFloat      _zoomX;
@property (assign) CGPoint      _layerZoomPoint;

@property (assign) CGRect       _bound;

- (void) _setCameraInBound;

@end

@implementation Camera
@synthesize _layer;
@synthesize _isZooming;
@synthesize _layerRefPoint;
@synthesize _zoomX;
@synthesize _layerZoomPoint;
@synthesize _bound;

+ (Camera*) getObject
{
    if ( ! _object )
    {
        _object                 = [[Camera alloc] init];
        _object._isZooming      = NO;
        _object._layerRefPoint  = _object._layer.position;
        _object._zoomX          = 1.0f;
        _object._bound          = CGRectMake((2235.833496),
                                             (-702.666992),
                                             (9525.833984)-(2435.833496),
                                             (-6423.666992)-(-872.666992));
    }
    
    return _object;
}

- (void) initCameraWithLayer: (CCLayer*) layer
{
    _object._layer  = layer;
}

- (void) moveCameraByPoint: (CGPoint) point
{
    // move camera
    CGPoint newPoint    = CGPointMake(_layerRefPoint.x + point.x,
                                      _layerRefPoint.y + point.y);

    _layerRefPoint  = newPoint;

    // set zoom
    [_object zoomTo:_object._zoomX];
}

- (void) setCameraToPoint: (CGPoint) point
{
    // move camera
    _layerRefPoint  = CGPointMake(-point.x, -point.y);

    // set zoom
    [_object zoomTo:_object._zoomX];
}

- (CGPoint) getPoint
{
    return _object._layerRefPoint;
}

- (CGFloat) getZoomX
{
    return _object._zoomX;
}

- (void) zoomTo: (CGFloat) zoomX
{
    // set vars
    _object._zoomX  = zoomX;

    // set zoom
    Camera* object  = [Camera getObject];
    CCLayer* layer  = object._layer;
    [layer setScale:zoomX];
    
    [self _setCameraInBound];
    
    // adjust layer
    _layerZoomPoint   = CGPointMake(object._layerRefPoint.x * object._zoomX,
                                    object._layerRefPoint.y * object._zoomX);
    
    [layer setPosition:_layerZoomPoint];
}

- (void) onUpdate: (float) deltaTime
{
}

#pragma mark - PIMPL

- (void) _setCameraInBound
{
    // calc scale
    CGSize screenSize   = [CCDirector sharedDirector].winSize;

    CGPoint currentPoint    = CGPointMake(-_layerRefPoint.x, -_layerRefPoint.y);
    
    float screenWidhHalf    = screenSize.width*.5;
    float screenHeightHalf  = screenSize.height*.5;
    
    CGPoint centerPoint     = CGPointMake(currentPoint.x + screenWidhHalf,
                                          currentPoint.y + screenHeightHalf);
    
    currentPoint    = centerPoint;
    
    CGSize actualSize   = CGSizeMake(screenSize.width/_layer.scale,
                                     screenSize.height/_layer.scale);
    
    float actualSizeWidthHalf   = actualSize.width*.5f;
    float actualSizeHeightHalf  = actualSize.height*.5f;
    
    CGRect bound            = CGRectMake(_bound.origin.x,
                                         _bound.origin.y,
                                         _bound.size.width,
                                         _bound.size.height
                                         );
    
    // manipulate point
    if ( currentPoint.x < bound.origin.x+actualSizeWidthHalf )
    {
        currentPoint.x  = bound.origin.x+actualSizeWidthHalf;
    }
    if ( currentPoint.y > bound.origin.y-actualSizeHeightHalf )
    {
        currentPoint.y  = bound.origin.y-actualSizeHeightHalf;
    }
    float maxX  = bound.origin.x + bound.size.width;
    float maxY  = bound.origin.y + bound.size.height;
    if ( currentPoint.x > maxX-actualSizeWidthHalf )
    {
        currentPoint.x  = maxX-actualSizeWidthHalf;
    }
    if ( currentPoint.y < maxY+actualSizeHeightHalf )
    {
        currentPoint.y  = maxY+actualSizeHeightHalf;
    }
    
    currentPoint    = CGPointMake(currentPoint.x - screenWidhHalf,
                                  currentPoint.y - screenHeightHalf);
    // set point
    _layerRefPoint  = CGPointMake(-currentPoint.x, -currentPoint.y);
}

@end
