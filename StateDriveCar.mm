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

#import "WindShield.h"

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

@property (assign) BOOL _isInWaterEvent;
@property (assign) BOOL _isInRoughEvent;
@property (assign) BOOL _isInWaterEventLastFrame;
@property (assign) BOOL _isInRoughEventLastFrame;

@property (assign) float    _carAcceleration;
@property (assign) float    _carBreakDeAcceleration;
@property (assign) float    _carNormalDeAcceleration;
@property (assign) float    _carMaxSpeed;
@property (assign) float    _carSpeedLimit;
@property (assign) float    _carMinSpeed;
@property (assign) float    _carGearDAcceleration;

@property (assign) float    _timeSpeed;
@property (assign) float    _timeSlowMotion;

@property (assign) float    _dangerousAngle;

@property (assign) CGPoint  _dragStart;
@property (assign) CGPoint  _dragEnd;
@property (assign) BOOL     _isDragging;
@property (assign) double   _dragTime;

@property (assign) float    _camZoomTarget;
@property (assign) float    _camZoomSpeed;
@property (assign) float    _camZoomInMax;
@property (assign) float    _camZoomOutMax;

- (void) _startSlowMotion;
- (void) _stopSlowMotion;

- (void) _moveCarWithTime: (float) deltaTime realTime: (float) realTime;

- (BOOL) _isDangerousBendWithPoint01:(CGPoint) point_01
                             point02:(CGPoint) point_02
                             point03:(CGPoint) point_03;

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

@synthesize _carAcceleration;
@synthesize _carBreakDeAcceleration;
@synthesize _carNormalDeAcceleration;

@synthesize _carMaxSpeed;
@synthesize _carSpeedLimit;
@synthesize _carMinSpeed;
@synthesize _carGearDAcceleration;

@synthesize _timeSpeed;
@synthesize _timeSlowMotion;

@synthesize _dangerousAngle;

@synthesize _dragStart;
@synthesize _dragEnd;
@synthesize _isDragging;
@synthesize _dragTime;

@synthesize _camZoomTarget;
@synthesize _camZoomSpeed;
@synthesize _camZoomInMax;
@synthesize _camZoomOutMax;

vector<TrVertex>    _allVertices;
vector<TrVertex>    _vertexRoute;
vector<TrEdge>      _edgeRoute;

@synthesize _currentMission;

- (void) onStart
{
    _carAcceleration            = 120.0f;
    _carBreakDeAcceleration     = -300.0f;
    _carNormalDeAcceleration    = -10.0f;
    _carGearDAcceleration       = 50.0f;
    
    _carMaxSpeed    = 600.0f;
    _carMinSpeed    = 50.0f;
    _carSpeedLimit  = ( 0.8 * ( _carMaxSpeed - _carMinSpeed ) ) + _carMinSpeed;
    
    _timeSpeed      = 1.0f;
    _timeSlowMotion = 0.2f;
    
    _dangerousAngle = 100.0f;
    
    _dragStart  = CGPointMake(0.0f, 0.0f);
    _dragEnd    = CGPointMake(0.0f, 0.0f);
    _isDragging = NO;
    _dragTime   = 0.0f;
    
    // load route data
    RouteGraph& routeGraph  = [World GetRouteGraph];
    _allVertices    = routeGraph.GetAllVertices();
    _vertexRoute    = routeGraph.GetVertexRoute();
    _edgeRoute      = routeGraph.GetEdgeRoute();
    
    _camZoomTarget      = [[Camera getObject] getZoomX];
    _camZoomSpeed       = 0.3f;
    _camZoomInMax       = 0.5;
    _camZoomOutMax      = 0.2;

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
    
    // set route lenght
    double routeLength  = routeGraph.GetRouteLength();
    printf ("route length: %lf", routeLength);
    printf ("\n");
    
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
    // timing with speed
    float realTime  = deltaTime;
    deltaTime *= _timeSpeed;
    
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
            
            CGPoint carTarget   = CGPointMake(0.0f, 0.0f);
            if ( _edgeRoute[0].subPoints.size() > 0 )
            {
                carTarget   = [UtilVec convertVecIfRetina:_edgeRoute[0].subPoints[0]];
            }
            else
            {
                int vertexEndCode   = _edgeRoute[0].vertexEnd;
                carTarget   = [UtilVec convertVecIfRetina:_vertexRoute[vertexEndCode].point];
            }
            
            [Car setTarget:carTarget];
            //[Car setSpeed:300.0f];
            //[Car setSpeed:30.0f];
            [Car setSpeed:0.0f];
            [Car Update:deltaTime];
            
            CGRect carBoundingBox   = [Car getBoundingBox];
            printf ("car bounding box: %f, %f, %f, %f",
                    carBoundingBox.origin.x,
                    carBoundingBox.origin.y,
                    carBoundingBox.size.width,
                    carBoundingBox.size.height);
            printf ("\n");
            
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
            
            // Car
            [Car showCar];
            
            // Init fuel
            [[Console getObject] SetFuelNorm:1.0f];
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT:
        {
            CCLOG(@"on STATE_DRIVE_CAR_DRIVE_CAR_SET_CHECKPOINT state");
        }
            break;
        case STATE_DRIVE_CAR_DRIVE_CAR_LERP:
        {
            //---------------------------------------------------------
            // calculate car speed
            BOOL isAccel    = [[Console getObject] getIsTouchingAccel];
            BOOL isBreak    = [[Console getObject] getIsTouchingBreak];
            
            float a = _carNormalDeAcceleration;
            if ( isAccel )
            {
                a += _carAcceleration;
            }
            if ( isBreak )
            {
                a += _carBreakDeAcceleration;
            }
            
            float deltaVelocity = a * deltaTime;
            
            CGFloat currentSpeed    = [Car getSpeed];
            float netCarSpeed       = currentSpeed+deltaVelocity;
            if ( netCarSpeed > _carMaxSpeed )
                netCarSpeed = _carMaxSpeed;
            else if ( netCarSpeed < 0.0f )
            {
                netCarSpeed = 0.0f;
            }
            
            if ( netCarSpeed < _carMinSpeed && !isBreak )
            {
                float deltaVelocity = _carGearDAcceleration * deltaTime;
                netCarSpeed += deltaVelocity;
            }
            
            [Car setSpeed:netCarSpeed];
            
            // set camera zooming
            float zoomCurrent   = [[Camera getObject] getZoomX];
            
            // calculate the final cam zoom by speed
            float deltaSpeed   = _carMaxSpeed - 0.0f;
            float deltaZoom    = _camZoomOutMax - _camZoomInMax;
            float zoomTarget    = ( netCarSpeed * deltaZoom / deltaSpeed ) + _camZoomInMax;
            _camZoomTarget  = zoomTarget;
            
            // interpolate zoom to target
            float deltaZoomWithTime     = _camZoomSpeed * realTime;
            float zoomDistance          = zoomTarget - zoomCurrent;
            float zoomDirection         = 0.0f;
            if ( zoomDistance == 0.0f )
                zoomDirection   = 0.0f;
            else
                zoomDirection   = ( zoomDistance / (float)ABS(zoomDistance) );
                    
            float zoomBy                = zoomDirection * deltaZoomWithTime;
            
            float nextZoom  = zoomCurrent + zoomBy;
            
            if ( zoomCurrent < zoomTarget )
                if ( nextZoom > zoomTarget )
                    nextZoom    = zoomTarget;
            
            if ( zoomCurrent > zoomTarget )
                if ( nextZoom < zoomTarget )
                    nextZoom    = zoomTarget;
            
            [[Camera getObject] zoomTo:nextZoom];
            
            // reduce fuel
            float fuelNorm  = [[Console getObject] GetFuelNorm];
            
            if ( isAccel )
            {
                fuelNorm -= (deltaTime*0.06f);
            }
            
            [[Console getObject] SetFuelNorm:fuelNorm];
            [[Console getObject] Update:deltaTime];
            
            if ( ! [Car isPlayingAnyAnim] )
            {
                [self _moveCarWithTime:deltaTime realTime:realTime];
            }
            
            // update event
            [[EventHandler getObject] onUpdate:deltaTime];
            
            // update combo
            [[ComboPlayer getObject] Update:deltaTime realTime:realTime];
            
            // update car
            [Car Update:deltaTime];
            
            // camera to the car
            CGPoint camPoint    = [Car getPosition];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [[Camera getObject] setCameraToPoint:camPoint];
            
            // Draging and time
            if ( _isDragging )
            {
                _dragTime += realTime;
            }
        }
            break;
        case STATE_DRIVE_CAR_REACH_TARGET:
        {
            printf ( "car is reaching the target!!!\n" );
            _currentState   = STATE_DRIVE_CAR_FINISH;
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
    BOOL isComboPlaying = [[ComboPlayer getObject] isPlayingEvent];

    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    _dragStart  = location;
    _isDragging = YES;
    
    if ( isComboPlaying )
    {
        [[ComboPlayer getObject] touchButtonAtPoint:location];
    }
    
    [[Console getObject] touchButtonAtPoint:location];
    
    return YES;
}

- (void) onTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    [[Console getObject] touchMoveAtPoint:location];
}

- (void) onTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location    = [[CCDirector sharedDirector] convertToGL:location];
    
    _dragEnd    = location;
    CGPoint dragElapse  = CGPointMake(_dragEnd.x - _dragStart.x,
                                      _dragEnd.y - _dragStart.y);
    float dragDistance  = sqrtf(dragElapse.x*dragElapse.x + dragElapse.y*dragElapse.y);
    
    if (_currentState == STATE_DRIVE_CAR_DRIVE_CAR_LERP )
    {
        if ( [[WindShield getObject] hasAnythingOnWindshield] )
        {
            if ( dragDistance >= 10.0f )
            {
                if ( _dragTime <= 1.0 )
                {
                    [[WindShield getObject] clearAllVisionBarrier];
                }
            }
        }
    }
    
    _isDragging = NO;
    _dragTime   = 0.0;
    
    [[Console getObject] unTouchButtonAtPoint:location];
}

- (void) onGetStringMessage: (NSString*) message
{
    
}

#pragma mark - EventHandlerDelegate

- (void) onStartEvent:(Event *)event;
{
    [[ComboPlayer getObject] startEvent:event];
    
    [self _startSlowMotion];
}

- (void) onEventFinished:(Event *)event isSuccess:(BOOL)isSuccess
{
    [self _stopSlowMotion];
    
    // play failed animation
    if ( ! isSuccess )
    {
        if ( [event.eventName isEqualToString:@"water"] )
        {
            [Car playSwerveAnim];
            [[WindShield getObject] showWater];
        }
        else if ( [event.eventName isEqualToString:@"rough"] )
        {
            
        }
    }
}

#pragma mark - PIMPL

- (void) _moveCarWithTime: (float) deltaTime realTime: (float) realTime
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
    
    //---------------------------------------------------------
    
    // set current distance
    float carMoveThisFrame  = sqrtf(carMoveVec.x * carMoveVec.x +
                                    carMoveVec.y * carMoveVec.y );
    _carMovedDistance += carMoveThisFrame;
    
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
        
        // increase point
        ++_cSubPointId;
        
        // check is car overshooting here
        BOOL isNeedCheckOvershoot   = YES;
        if ( _cSubPointId <= 0 || _cSubPointId > ( subPointsSize - 2 ) )
        {
            isNeedCheckOvershoot    = NO;
        }
        else
        {
            // ..
            int id_01 = _cSubPointId - 1;
            int id_02 = _cSubPointId;
            int id_03 = _cSubPointId + 1;
            
            CGPoint point_01    = _cMovingPoints[id_01];
            CGPoint point_02    = _cMovingPoints[id_02];
            CGPoint point_03    = _cMovingPoints[id_03];
            
                        
            if ( [self _isDangerousBendWithPoint01:point_01
                                           point02:point_02
                                           point03:point_03] )
            {
                // car speed
                float speed = [Car getSpeed];
                
                // check0
                if ( speed > _carSpeedLimit )
                {
                    [Car playOvershootAnim];
                }
            }
        }
    }
    
    // update car properties from route
    [Car setTarget:carNextPosition];
    [Car setPosition:carNextPosition];
}

- (void) _startSlowMotion
{
    _timeSpeed  = _timeSlowMotion;
}

- (void) _stopSlowMotion
{
    _timeSpeed  = 1.0f;
}

- (BOOL) _isDangerousBendWithPoint01:(CGPoint) point_01
                             point02:(CGPoint) point_02
                             point03:(CGPoint) point_03
{
    CGPoint vec_01  = CGPointMake(point_01.x - point_02.x,
                                  point_01.y - point_02.y);
    CGPoint vec_02  = CGPointMake(point_03.x - point_02.x,
                                  point_03.y - point_02.y);
    float abs_01    = sqrtf(vec_01.x*vec_01.x + vec_01.y*vec_01.y);
    float abs_02    = sqrtf(vec_02.x*vec_02.x + vec_02.y*vec_02.y);
    CGPoint vec_01_norm = CGPointMake(vec_01.x / abs_01,
                                      vec_01.y / abs_01);
    CGPoint vec_02_norm = CGPointMake(vec_02.x / abs_02,
                                      vec_02.y / abs_02);
    
    // angle
    // cos θ = (a·b)/(|a||b|);
    float dotValue  = vec_01_norm.x * vec_02_norm.x + vec_01_norm.y * vec_02_norm.y;
    
    float cosf      = dotValue;
    
    float radian    = acosf(cosf);
    float angle     = radian * 180.0f / M_PI;

    if ( angle < _dangerousAngle )
    {
        return YES;
    }
    
    return NO;
}

@end
