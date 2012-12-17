//
//  FocusZoom.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/17/55 BE.
//
//

#import "FocusZoom.h"
#import <vector>
using namespace std;

#import "Car.h"
#import "Camera.h"

FocusZoom*  _s_focusZoom    = nil;

@interface FocusZoom()

@property (assign) BOOL isFocusing;
@property (assign) vector<CGPoint> focusPoint;
@property (assign) int cFocusingIndex;

@end

@implementation FocusZoom

+ (FocusZoom*) getObject
{
    if ( ! _s_focusZoom )
    {
        _s_focusZoom    = [[FocusZoom alloc] init];
    }
    
    return _s_focusZoom;
}

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _focusPoint.push_back(CGPointMake(6023.623047, -5147.246094));
        _focusPoint.push_back(CGPointMake(6973.623047, -5331.456543));
        _focusPoint.push_back(CGPointMake(8299.518555, -5144.616211));
        _focusPoint.push_back(CGPointMake(6099.518066, -2249.877930));
        _focusPoint.push_back(CGPointMake(8033.728027, -4418.299316));
        _focusPoint.push_back(CGPointMake(8662.675781, -4418.299316));
    }
    return self;
}

- (BOOL) getIsFocusing
{
    return _isFocusing;
}

- (int) getFocusPointIndex
{
    return _cFocusingIndex;
}

- (CGPoint) getFocusingPoint
{
    if ( ! _isFocusing )
        return CGPointMake(0.0f, 0.0f);
    
    return _focusPoint[_cFocusingIndex];
}

- (void) update:(float)dt;
{
    BOOL isFocusing = NO;
    BOOL isCarInBound   = YES;
    
    CGPoint cCarPoint   = [Car getPosition];
    CGPoint cCamPoint   = [[Camera getObject] getPoint];
    CGSize winSize  = [CCDirector sharedDirector].winSize;
    cCamPoint.x = -cCamPoint.x;
    cCamPoint.y = -cCamPoint.y;
    cCamPoint.x = cCamPoint.x + winSize.width*0.5f;
    cCamPoint.y = cCamPoint.y + winSize.height*0.5f;
    
    float dx    = cCarPoint.x - cCamPoint.x;
    float dy    = cCarPoint.y - cCamPoint.y;
    
    if ( dx < 0.0f )
        dx  = -dx;
    if ( dy < 0.0f )
        dy  = -dy;
    
    //float expectPointDistance   = 420.0f;
    float expectPointDistance   = 620.0f;
    float cPointDistance        = dx + dy;
    
    if ( cPointDistance > expectPointDistance )
    {
        isCarInBound    = NO;
    }
    
    if ( isCarInBound )
    {
        for ( int i=0; i<_focusPoint.size(); ++i )
        {
            CGPoint cFocusPoint = _focusPoint[i];
            
            float dx    = cFocusPoint.x - cCarPoint.x;
            float dy    = cFocusPoint.y - cCarPoint.y;
            
            if ( dx < 0.0f )
                dx  = -dx;
            if ( dy < 0.0f )
                dy  = -dy;
            
            float expectPointDistance = 1000.0f;
            float cPointDistance    = dx + dy;
            
            if ( cPointDistance <= expectPointDistance )
            {
                isFocusing = YES;
                _cFocusingIndex = i;
            }
        }
    }
    
    _isFocusing = isFocusing;
}

@end
