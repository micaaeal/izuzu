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

@property (assign) BOOL _isInWaterEvent;
@property (assign) BOOL _isInRoughEvent;
@property (assign) BOOL _isInWaterEventLastFrame;
@property (assign) BOOL _isInRoughEventLastFrame;

@property (assign) float    _carAcceleration;
@property (assign) float    _carBreakDeAcceleration;
@property (assign) float    _carNormalDeAcceleration;
@property (assign) float    _carMaxSpeed;
@property (assign) float    _carMinSpeed;

@property (assign) float    _timeSpeed;
@property (assign) float    _timeSlowMotion;

- (void) _startSlowMotion;
- (void) _stopSlowMotion;

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
@synthesize _carMinSpeed;

@synthesize _timeSpeed;
@synthesize _timeSlowMotion;

vector<TrVertex>    _allVertices;
vector<TrVertex>    _vertexRoute;
vector<TrEdge>      _edgeRoute;

@synthesize _currentMission;

- (void) onStart
{
    
    _carAcceleration            = 120.0f;
    _carBreakDeAcceleration     = -300.0f;
    _carNormalDeAcceleration    = -10.0f;
    
    _carMaxSpeed    = 600.0f;
    _carMinSpeed    = 0.0f;
    
    _timeSpeed      = 1.0f;
    _timeSlowMotion = 0.5f;
    
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
            
            CGFloat carInitSpeed    = [Car getSpeed];
            float netCarSpeed       = carInitSpeed+deltaVelocity;
            if ( netCarSpeed > _carMaxSpeed )
                netCarSpeed = _carMaxSpeed;
            else if ( netCarSpeed < _carMinSpeed )
                netCarSpeed = _carMinSpeed;
            [Car setSpeed:netCarSpeed];
            
            // reduce fuel
            float fuelNorm  = [[Console getObject] GetFuelNorm];
            
            if ( isAccel )
            {
                fuelNorm -= (deltaTime*0.06f);
            }
            
            [[Console getObject] SetFuelNorm:fuelNorm];
            [[Console getObject] Update:deltaTime];
            
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
            
            // update car properties from route
            [Car setTarget:carNextPosition];
            [Car setPosition:carNextPosition];
            
            // update event
            [[EventHandler getObject] onUpdate:deltaTime];
            
            // update combo
            [[ComboPlayer getObject] Update:deltaTime];
        
            // update car
            [Car Update:deltaTime];
            
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
    BOOL isComboPlaying = [[ComboPlayer getObject] isPlayingCombo];

    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
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
    location = [[CCDirector sharedDirector] convertToGL:location];
    [[Console getObject] unTouchButtonAtPoint:location];
}

- (void) onGetStringMessage: (NSString*) message
{
    
}

#pragma mark - EventHandlerDelegate

/*
- (void) onTouchingInWithEvent: (Event*) event isComboSuccess:(BOOL)isComboSuccess
{
    if ( isComboSuccess )
    {
        //[[ComboPlayer getObject] finishCombo:YES];        
    }
    else
    {
        if ( [event.typeName isEqualToString:@"water"] )
        {
            [Car playSwerveAnim];
        }
        else if ( [event.typeName isEqualToString:@"rough"] )
        {
            [Car playRoughAnim];
        }   
        
        [[ComboPlayer getObject] finishCombo:NO];
    }
}

- (void) onTouchingOutWithEvent: (Event*) event
{
    if ( [event.typeName isEqualToString:@"water"] )
    {
        [Car stopSwerveAnim];
    }
    else if ( [event.typeName isEqualToString:@"rough"] )
    {
        [Car stopRoughAnim];
    }
}
*/

- (void) onStartCombo: (Combo*) combo
{
    printf ("onStartCombo with code: %d", combo.code.intValue);
    printf ("\n");
    
    [[ComboPlayer getObject] startCombo:combo];
    
    [self _startSlowMotion];
}

- (void) onComboFinished:(Combo *)combo isSuccess:(BOOL)isSuccess
{
    printf ("onComboFinished: withParameter: %s", isSuccess? "Success" : "Failed");
    printf ("\n");
    
    //[[EventHandler getObject] finishCombo:combo];
    
    [self _stopSlowMotion];
}

#pragma mark - PIMPL

- (void) _startSlowMotion
{
    _timeSpeed  = _timeSlowMotion;
}

- (void) _stopSlowMotion
{
    _timeSpeed  = 1.0f;
}

@end
