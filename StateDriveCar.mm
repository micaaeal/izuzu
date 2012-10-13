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

#import "Utils.h"
#import "Mission.h"

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

@property (assign) vector<CGPoint>  _cMovingPoints;
@property (assign) int              _cSubPointId;
@property (assign) float            _cDistanceToMoveNextFrame;
@property (assign) long double      _carMovedDistance;

@property (retain) Mission*         _currentMission;

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

@synthesize _cMovingPoints;
@synthesize _cSubPointId;
@synthesize _cDistanceToMoveNextFrame;

@synthesize _carMovedDistance;

vector<TrVertex>    _allVertices;
vector<TrVertex>    _vertexRoute;
vector<TrEdge>      _edgeRoute;

@synthesize _currentMission;

- (void) onStart
{
    // load route data
    RouteGraph& routeGraph  = [World GetRouteGraph];
    _allVertices    = routeGraph.GetAllVertices();
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
    _currentMission = [Mission GetMissionFromCode:[Mission getCurrentMissionCode]];
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
            CGPoint camPoint    = [UtilVec convertVecIfRetina:_vertexRoute[0].point];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [cam setCameraToPoint:camPoint];
            
            // set car
            CGPoint& firstVertexPoint   = _vertexRoute[0].point;
            CCLOG(@"vertex point x: %f y: %f", firstVertexPoint.x, firstVertexPoint.y);
            
            CGPoint carPosition = [UtilVec convertVecIfRetina:firstVertexPoint];
            [Car setPosition:carPosition];
            CGPoint carTarget   = [UtilVec convertVecIfRetina:_edgeRoute[0].subPoints[0]];
            [Car setTarget:carTarget];
            [Car setSpeed:300.0f];
            
            // set moving point as route
            _cMovingPoints.clear();
            
            TrEdge cEdge;
            for ( int i=0; i<_edgeRoute.size(); ++i )
            {
                cEdge    = _edgeRoute[i];
                CGPoint cMovingPoint    = [UtilVec convertVecIfRetina:_allVertices[cEdge.vertexStart].point];
                _cMovingPoints.push_back(cMovingPoint);
                for ( int j=0; j<cEdge.subPoints.size(); ++j )
                {
                    CGPoint cMovingPoint    = [UtilVec convertVecIfRetina:cEdge.subPoints[j]];
                    _cMovingPoints.push_back(cMovingPoint);
                }
            }
            CGPoint cEndPoint   = [UtilVec convertVecIfRetina:_allVertices[cEdge.vertexEnd].point];
            _cMovingPoints.push_back(cEndPoint);
            
            // reset ref
            _cSubPointId    = 0;
            _cDistanceToMoveNextFrame    = 0.0f;
            
            _currentState   = STATE_DRIVE_CAR_DRIVE_CAR_LERP;
            _carMovedDistance   = 0.0f;
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT:
        {
            CCLOG(@"on STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT state");
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_LERP:
        {
            // flags
            BOOL isEndThisSubPoint = NO;
            
            //---------------------------------------------------------
            int subPointsSize   = _cMovingPoints.size();
            CGPoint cSubPoint       = _cMovingPoints[_cSubPointId];
            CGPoint nextSubPoint    = _cMovingPoints[_cSubPointId+1];
            CGPoint cCarPoint       = [Car getPosition];
            CGFloat cCarSpeed       = [Car getSpeed];
            
            // get new position
            CGPoint p2pVec      = CGPointMake(nextSubPoint.x - cSubPoint.x,
                                              nextSubPoint.y - cSubPoint.y);
            
            CGFloat p2pVecLength    = sqrtf( ( p2pVec.x * p2pVec.x ) + ( p2pVec.y * p2pVec.y ) );
            CGPoint p2pVecNorm      = CGPointMake(p2pVec.x / p2pVecLength,
                                                  p2pVec.y / p2pVecLength);
            
            // car distance this frame
            CGFloat carDistance     = cCarSpeed * deltaTime;
            carDistance += _cDistanceToMoveNextFrame;
            _cDistanceToMoveNextFrame   = 0.0f;
            
            CGPoint carMoveVec      = CGPointMake(carDistance * p2pVecNorm.x,
                                                  carDistance * p2pVecNorm.y);
            
            CGPoint carNewVec       = CGPointMake(cCarPoint.x + carMoveVec.x,
                                                  cCarPoint.y + carMoveVec.y);
            
            // test is beyond the target
            CGPoint car2pVec    = CGPointMake(nextSubPoint.x - carNewVec.x,
                                              nextSubPoint.y - carNewVec.y);
            CGFloat dotVec      = (p2pVec.x * car2pVec.x) + (p2pVec.y * car2pVec.y);
            
            BOOL isCarGoBeyond  = dotVec <= 0.0f ? YES : NO;
            
            CGPoint carNextPosition    = carNewVec;
            if ( isCarGoBeyond )
            {
                isEndThisSubPoint   = YES;
                carNextPosition     = nextSubPoint;
                
                CGPoint p2CarVec    = CGPointMake(carNewVec.x-cSubPoint.x,
                                                  carNewVec.y-cSubPoint.y);
                CGFloat p2CarLength = sqrtf( p2CarVec.x*p2CarVec.x + p2CarVec.y*p2CarVec.y );
                _cDistanceToMoveNextFrame   = p2CarLength - p2pVecLength;
            }
            
            // set car rotation and position
            [Car setTarget:carNextPosition];
            [Car setPosition:carNextPosition];
            
            // camera to the car
            CGPoint camPoint    = [Car getPosition];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [[Camera getObject] setCameraToPoint:camPoint];
            //---------------------------------------------------------
            
            // set current distance
            float carMoveThisFrame  = sqrtf(carMoveVec.x * carMoveVec.x +
                                            carMoveVec.y * carMoveVec.y );
            _carMovedDistance += carMoveThisFrame;
            
            // check for event
            Event* cEvent   = [_currentMission GetEventFromDistance:_carMovedDistance];
            if ( cEvent )
            {
#warning .... to be continued here !!
//                printf ("fire event here");
//                printf ("\n");
            }
            
            // if last period
            BOOL isLastSubPointPeriod   = NO;
            if ( _cSubPointId >= subPointsSize-2 )
            {
                isLastSubPointPeriod    = YES;
            }
            
            // check is end
            if ( isLastSubPointPeriod && isEndThisSubPoint )
            {
                _currentState   = STATE_DRIVE_CAR_REACH_TARGET;
            }
            else if ( isEndThisSubPoint )
            {
                ++_cSubPointId;
            }
        }
            break;
        case STATE_DRIVE_CAR_REACH_TARGET:
        {
            printf ( "car is reaching the target!!!\n" );
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

- (void) onGetStringMessage: (NSString*) message
{
    
}

@end
