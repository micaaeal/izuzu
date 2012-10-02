//
//  StateDriveCar.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import "StateDriveCar.h"
#import "cocos2d.h"

#import "World.h"
#import "Car.h"

#import "RouteGraph.h"
#import <vector>
using namespace std;

#import "Camera.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
enum STATE_DRIVE_CAR
{
    STATE_DRIVE_CAR_NONE = 0,
    
    STATE_DRIVE_CAR_START,
    STATE_DRIVE_CAR_LOAD_ROUTE,
    STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT,
    STATE_DRIVE_CAR_DRIVE_CAR_LERP,
    STATE_DRIVE_CAR_REACH_TARGET,
    STATE_DRIVE_CAR_FINISH,
    
    STATE_DRIVE_CAR_COUNT,
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface StateDriveCar()

@property (assign) float _camInitX;
@property (assign) float _camInitY;
@property (assign) float _camInitZ;
@property (assign) float _camInitEyeX;
@property (assign) float _camInitEyeY;
@property (assign) float _camInitEyeZ;
@property (assign) STATE_DRIVE_CAR  _currentState;

@property (assign) TrEdge           _cEdge;
@property (assign) vector<CGPoint>  _cSubPoints;
@property (assign) int              _cSubPointId;
@property (assign) float            _cDistanceToMoveNextFrame;

@end

@implementation StateDriveCar
@synthesize layer;
@synthesize _camInitX;
@synthesize _camInitY;
@synthesize _camInitZ;
@synthesize _camInitEyeX;
@synthesize _camInitEyeY;
@synthesize _camInitEyeZ;
@synthesize _currentState;

@synthesize _cEdge;
@synthesize _cSubPoints;
@synthesize _cSubPointId;
@synthesize _cDistanceToMoveNextFrame;

vector<TrVertex>    _vertexRoute;
vector<TrEdge>      _edgeRoute;

- (void) onStart
{
    // load route data
    RouteGraph& routeGraph  = [World GetRouteGraph];
    _vertexRoute    = routeGraph.GetVertexRoute();
    _edgeRoute      = routeGraph.GetEdgeRoute();

    printf ("edge route");
    printf ("\n");
    for (int i=0; i<_edgeRoute.size(); ++i)
    {
        TrEdge& cEdge   = _edgeRoute[i];
        printf ("vertex_start: %d", cEdge.vertexStart);
        printf ("-");
        printf ("vertex_end: %d", cEdge.vertexEnd);
        printf ("\n");
    }
    
    // set init state
    _currentState   = STATE_DRIVE_CAR_NONE;
    
    // start drive
    
}

- (void) onFinish
{
    
}

- (BOOL) onUpdate: (float) deltaTime // if retuen YES, means end current state
{
    switch (_currentState) {
        case STATE_DRIVE_CAR_NONE:
        {
            _currentState   = STATE_DRIVE_CAR_START;
        }
            break;
        case STATE_DRIVE_CAR_START:
        {
            _currentState   = STATE_DRIVE_CAR_LOAD_ROUTE;
        }
            break;
        case STATE_DRIVE_CAR_LOAD_ROUTE:
        {
            // set currentVertexPtr from the @Mission
            Camera* cam = [Camera getObject];
            [cam setCameraToPoint:_vertexRoute[0].point];
            
            // set car
            CGPoint& firstVertexPoint   = _vertexRoute[0].point;
            
            CCLOG(@"vertex poitn x: %f y: %f", firstVertexPoint.x, firstVertexPoint.y);
            
            [Car setPosition:firstVertexPoint];
            [Car setTarget:_edgeRoute[0].subPoints[0]];
            [Car setSpeed:50.0f];
            
            // set first Edge
            _cEdge  = _edgeRoute[0];
            _cSubPoints.clear();
            _cSubPoints.push_back(_vertexRoute[_cEdge.vertexStart].point);
            for ( int i=0; i<_cEdge.subPoints.size(); ++i )
            {
                _cSubPoints.push_back(_cEdge.subPoints[i]);
            }
            _cSubPoints.push_back(_vertexRoute[_cEdge.vertexEnd].point);
            _cSubPointId    = 0;
            _cDistanceToMoveNextFrame    = 0.0f;
            
            _currentState   = STATE_DRIVE_CAR_DRIVE_CAR_LERP;
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT:
        {
            CCLOG(@"on STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT state");
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_LERP:
        {
            break;
            
            int subPointsSize   = _cSubPoints.size();

            CGPoint cSubPoint       = _cSubPoints[_cSubPointId];
            CGPoint nextSubPoint    = _cSubPoints[_cSubPointId+1];
            
            float deltaX    = nextSubPoint.x - cSubPoint.x;
            float deltaY    = nextSubPoint.y - cSubPoint.y;
            if ( deltaX == 0.0f )
                deltaX  = 0.000001f;
            float radian    = tanf( deltaY / deltaX );
            
            while ( radian > M_2_PI )
            {
                radian -= M_2_PI;
            }
            
            float directionGuideX   = 1.0f;
            float directionGuideY   = 1.0f;
            if ( 0.00f <= radian < M_PI_2)
            {
                directionGuideX = 1.0f;
                directionGuideY = 1.0f;
            }
            else if ( M_PI_2 <= radian < M_PI )
            {
                directionGuideX = -1.0f;
                directionGuideY = 1.0f;
            }
            else if ( M_PI <= radian < M_PI + M_PI_2 )
            {
                directionGuideX = -1.0f;
                directionGuideY = -1.0f;
            }
            else
            {
                directionGuideX = 1.0f;
                directionGuideY = -1.0f;
            }
            
            //float angle     = radian * 180.0f / M_PI + 90.0f;
            //float netDistance  = deltaX*deltaX + deltaY*deltaY;
            
            CGPoint carPos  = [Car getPosition];
            float remainX   = nextSubPoint.x - carPos.x;
            float remainY   = nextSubPoint.y - carPos.y;

//            printf ("remain x: %f remain y: %f", remainX*directionGuideX, remainY*directionGuideY);
//            printf ("\n");

            float remainDistance    = sqrtf( remainX*remainX + remainY*remainY );
            
//            printf ("remain distance: %f", remainDistance);
//            printf ("\n");
            
            float carSpeed      = [Car getSpeed];
            float distanceToMove    = (carSpeed * deltaTime) + _cDistanceToMoveNextFrame;
            _cDistanceToMoveNextFrame   = 0.0f;
            
            float distanceCanMove   = (distanceToMove <= remainDistance)? distanceToMove : remainDistance;
            
            float distanceToMoveNextFrame = distanceToMove - distanceCanMove;
            
            if ( distanceToMoveNextFrame > 0.0f )
            {
                _cDistanceToMoveNextFrame   = distanceToMoveNextFrame;
            }
        
            float directionX  = 1.0f;
            float directionY  = 1.0f;
            if ( deltaX < 0.0f )
                directionX    = -1.0f;
            if ( deltaY < 0.0f )
                directionY    = -1.0f;
            
            float nextX = carPos.x + ( cos(radian) * distanceCanMove * directionX );
            float nextY = carPos.y + ( sin(radian) * distanceCanMove * directionY );
         
            CGPoint carNextPos  = CGPointMake(nextX, nextY);
            [Car setPosition:carNextPos];
            
            BOOL isLastPeriod   = (_cSubPointId+1 >= subPointsSize) ? YES : NO;
            if ( isLastPeriod )
            {
                if ( distanceCanMove >= remainDistance - 0.00001 )
                {
                    _currentState   = STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT;
                }
            }
        }
            break;
        case STATE_DRIVE_CAR_REACH_TARGET:
        {
            
        }
            break;
        case STATE_DRIVE_CAR_FINISH:
        {
            
        }
            break;
            
        default:
            break;
    }

    return YES;
}

- (void) onRender
{
    
}

- (BOOL) onTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void) onTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) onTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
