//
//  StateSelectRoute.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import "StateSelectRoute.h"
#import "cocos2d.h"
#import "World.h"
#import "RouteGraph.h"
#import <vector>
#import "Camera.h"
using namespace std;
#import "Utils.h"
#import "Mission.h"
#import "Order.h"
#import "Car.h"
#import "WindShield.h"
#import "Score.h"
#import "EventHandler.h"
#import "Fade.h"
#import "MenuRouteGuide.h"

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
enum STATE_SELECT_ROUTE
{
    STATE_SELECT_ROUTE_NONE = 0,
    
    STATE_SELECT_ROUTE_START,
    STATE_SELECT_ROUTE_LOAD_ROUTE,
    STATE_SELECT_ROUTE_START_MOVE_CAMERA,
    STATE_SELECT_ROUTE_SELECT_ROUTE,
    
    STATE_SELECT_ROUTE_ON_SELECTNG_ROUTE,
    STATE_SELECT_ROUTE_ON_CALCEL_SELECTING,
    
    STATE_SELECT_ROUTE_MOVE_CAMERA,
    STATE_SELECT_ROUTE_CAMERA_STOP,
    STATE_SELECT_ROUTE_REACH_TARGET,
    STATE_SELECT_ROUTE_FINISH,
    
    STATE_SELECT_ROUTE_COUNT,
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- 
@interface StateSelectRoute()

@property (assign) vector<TrVertex>     _vertexRoute;
@property (assign) vector<TrEdge>       _edgeRoute;
@property (retain) MenuSelectRoute*     _menuSelectRoute;
@property (assign) TrVertex             _startVertex;
@property (assign) TrVertex             _finishVertex;
@property (assign) vector<TrVertex>     _currentConnectedVertices;

@property (assign) BOOL                 _hasSelectedRouteThisPoint;
@property (assign) STATE_SELECT_ROUTE   _currentState;

@property (assign) CGPoint              _currentCamPoint;

@property (assign) CGPoint              _touchAtBegin;
@property (assign) CGPoint              _touchDeltaLastFrame;

@property (assign) CGPoint              _nextVetexPoint;
@property (assign) CGPoint              _currentTouchPoint;

@property (retain) MenuRouteGuide*      _menuRouteGuide;

- (void) _setMenuButtonAtLastVertex;

@end

@implementation StateSelectRoute
@synthesize delegate;
@synthesize layer;
@synthesize _vertexRoute;
@synthesize _edgeRoute;
@synthesize _menuSelectRoute;
@synthesize _startVertex;
@synthesize _finishVertex;
@synthesize _currentConnectedVertices;
@synthesize _hasSelectedRouteThisPoint;
@synthesize _currentState;
@synthesize _currentCamPoint;
@synthesize _touchAtBegin;
@synthesize _touchDeltaLastFrame;
@synthesize _nextVetexPoint;
@synthesize _currentTouchPoint;
@synthesize _menuRouteGuide;

- (void) onStart
{
    // vers
    _currentState   = STATE_SELECT_ROUTE_START;
    _hasSelectedRouteThisPoint  = NO;
    
    // create select route array
    _menuSelectRoute   = [[MenuSelectRoute alloc] init];
    
    // create route guide
    _menuRouteGuide = [[MenuRouteGuide alloc] init];
    [_menuRouteGuide loadDataToLayer:layer];
    
    // clear routeGraph
    RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
    routeGraph.ClearRoute();
    
    [[WindShield getObject] clearAllVisionBarrier];
    
    [[Fade getObject] fadeOut];
}

- (void) onFinish
{
    // clear menu route
    MenuSelectRoute* cMenu  = _menuSelectRoute;
    
    for (int j=0; j<cMenu.routeCount; ++j)
    {
        [cMenu hideButtonAtIndex:j];
    }
    
    [_menuRouteGuide release];
    _menuRouteGuide = nil;
    
    [_menuSelectRoute release];
    _menuSelectRoute   = nil;
}

- (void) onRestart
{
    [[Fade getObject] fadeOut];
}

- (BOOL) onUpdate: (float) deltaTime // if retuen YES, means end current state
{
    switch (_currentState)
    {
        case STATE_SELECT_ROUTE_NONE:
        {
            _currentState   = STATE_SELECT_ROUTE_START;
        }
            break;
        case STATE_SELECT_ROUTE_START:
        {
            // Reset score
            [[Score getObject] reset];
            
            // Mission box
            int missionCode = [[Mission getObject] getCurrentMissionCode];
            Order* order    = [[Mission getObject] GetORderFromMissionCode:missionCode];
            CGPoint* pointArray = [order getOrderPositionArray];
            int orderCount  = [order getOrderCount];
            [[Mission getObject] ClearAllBoxSpritesFromMapLayer];
            for ( int i=0; i<orderCount; ++i)
            {
                [[Mission getObject] AddBoxSpriteToMapLayerAtPosition:pointArray[i]];
            }
            
            double missionTime  = [[Mission getObject] GetMissionTimeFromMissionCode:missionCode];
            [[Score getObject] setMissionTime:missionTime];
            Order* cOrder       = [[Mission getObject] GetORderFromMissionCode:missionCode];
            [cOrder getOrderCount];

            int cTotalOrder = [[Mission getObject] getCurrentTotalOrder];
            int cGotOrder   = [[Mission getObject] getCurrentGotOrder];
            
            [[Score getObject] setTotalOrder:cTotalOrder];
            [[Score getObject] setGotOrder:cGotOrder];
            
            // Car
            [[Car getObject] hideCar];
            
            // set currentVertexPtr from the @Mission
            int cMissionCode    = [[Mission getObject] getCurrentMissionCode];
            
            // all about route graph
            RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
            vector<TrVertex> allVertices    = routeGraph.GetAllVertices();
            
            int startVertex = [[Mission getObject] GetStartVertexFromMissionCode:cMissionCode];
            int endVertex   = [[Mission getObject] GetEndVertexFromMissionCode:cMissionCode];
            _startVertex    = allVertices[startVertex];
            _finishVertex   = allVertices[endVertex];
            
            // set mission start sign & win flag
            [[Mission getObject] setStarSignPoint:_startVertex.point];
            [[Mission getObject] setWinFlagPoint:_finishVertex.point];
            
            Camera* cam = [Camera getObject];
            CGPoint camPoint = [UtilVec convertVecIfRetina:_startVertex.point];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [cam setCameraToPoint:camPoint];
            
            routeGraph.PushVertex(_startVertex);
            
            // set camera first post
            [[Camera getObject] setCameraToPoint:_finishVertex.point];
            _currentCamPoint    = _finishVertex.point;
            
            // reset event sign
            [[EventHandler getObject] finishAllEvents];
            [[EventHandler getObject] hideSpeedLimitSign];
            
            // reset route
            [[World getObject] clearGeneratedPaths];
            
            // set state
            _currentState   = STATE_SELECT_ROUTE_START_MOVE_CAMERA;
        }
            break;
        case STATE_SELECT_ROUTE_START_MOVE_CAMERA:
        {
            CGPoint camStartPoint   = _finishVertex.point;
            CGPoint camEndPoint     = _startVertex.point;
            
            CGPoint cCamPoint       = _currentCamPoint;
            
            CGPoint toMoveVec       = CGPointMake(camEndPoint.x-camStartPoint.x,
                                                  camEndPoint.y-camStartPoint.y);
            float deltaPointLength  = sqrtf( toMoveVec.x*toMoveVec.x + toMoveVec.y*toMoveVec.y);
            CGPoint toMoveVecUnit   = CGPointMake(toMoveVec.x/deltaPointLength, toMoveVec.y/deltaPointLength);
            
            //float toMoveSpeed       = 300.0f;
            float toMoveSpeed       = 600.0f;
            float toMoveDistance    = deltaTime * toMoveSpeed;
            CGPoint toMoveVecAbsolute   = CGPointMake(toMoveVecUnit.x*toMoveDistance,
                                                      toMoveVecUnit.y*toMoveDistance);
            
            CGPoint newCamPoint     = CGPointMake(cCamPoint.x+toMoveVecAbsolute.x,
                                                  cCamPoint.y+toMoveVecAbsolute.y);
            
            CGPoint camToEndPointVec    = CGPointMake(camEndPoint.x-newCamPoint.x,
                                                      camEndPoint.y-newCamPoint.y);
            
            CGFloat dotVec      = (camToEndPointVec.x * toMoveVecUnit.x) + (camToEndPointVec.y * toMoveVecUnit.y);
            BOOL isCamBeyound   = dotVec <= 0.0f ? YES : NO;
            
            if ( isCamBeyound )
            {
                _currentCamPoint    = camEndPoint;
                
                CGPoint camPoint = [UtilVec convertVecIfRetina:camEndPoint];
                CGSize winSize  = [[CCDirector sharedDirector] winSize];
                camPoint.x -= (winSize.width * 0.5f);
                camPoint.y -= (winSize.height * 0.5f);
                [[Camera getObject] setCameraToPoint:camPoint];
                
                // set state
                _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
            }
            else
            {
                _currentCamPoint    = newCamPoint;
                
                CGPoint camPoint = [UtilVec convertVecIfRetina:newCamPoint];
                CGSize winSize  = [[CCDirector sharedDirector] winSize];
                camPoint.x -= (winSize.width * 0.5f);
                camPoint.y -= (winSize.height * 0.5f);
                [[Camera getObject] setCameraToPoint:camPoint];
                
                [[Camera getObject] setCameraToPoint:camPoint];
            }
        }
            break;
        case STATE_SELECT_ROUTE_LOAD_ROUTE:
        {
            // manipulate route graph
            [self _setMenuButtonAtLastVertex];
            
            // set flags
            _hasSelectedRouteThisPoint  = NO;
            
            // set state
            _currentState   = STATE_SELECT_ROUTE_SELECT_ROUTE;
            
            // generate paths
            [[World getObject] generatePathsFromRoute];
        }
            break;
        case STATE_SELECT_ROUTE_SELECT_ROUTE:
        {
            RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
            if ( routeGraph.GetHasCancelState() )
            {
                routeGraph.SetHasCancelState(false);
                _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
            }
            
            // old style state
            /*
            if ( _hasSelectedRouteThisPoint )
            {
                _currentState   = STATE_SELECT_ROUTE_MOVE_CAMERA;
            }
            /*/
            if ( _hasSelectedRouteThisPoint )
            {
                _currentState   = STATE_SELECT_ROUTE_ON_SELECTNG_ROUTE;
                
                RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
                routeGraph.GetConnectedVertices(_currentConnectedVertices);
                int vtSize  = routeGraph.GetVertexRoute().size();
                TrVertex formerVt       = routeGraph.GetVertexRoute()[vtSize-2];
                
                [_menuRouteGuide showLight];
                [_menuRouteGuide showRouteTarget];
                [_menuRouteGuide setLightPoserFrom:formerVt.point to:_currentTouchPoint];
                [_menuRouteGuide setRouteTargetPosition:_nextVetexPoint];
                [_menuRouteGuide setRouteTargetState:NO];
            }
            /**/
        }
            break;
        case STATE_SELECT_ROUTE_ON_SELECTNG_ROUTE:
        {
            //_nextVetexPoint
            CGPoint diffPoint   = CGPointMake(_nextVetexPoint.x - _currentTouchPoint.x,
                                              _nextVetexPoint.y - _currentTouchPoint.y);
            
            float cLength           = ABS(diffPoint.x) + ABS(diffPoint.y);
            float lengthInbound     = 120.0f;
            
            if ( cLength <= lengthInbound )
            {
                // show green status
                [_menuRouteGuide setRouteTargetState:YES];
            }
            else
            {
                [_menuRouteGuide setRouteTargetState:NO];
            }
            
            // set light
            RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
            routeGraph.GetConnectedVertices(_currentConnectedVertices);
            int vtSize  = routeGraph.GetVertexRoute().size();
            TrVertex formerVt       = routeGraph.GetVertexRoute()[vtSize-2];
            
            [_menuRouteGuide setLightPoserFrom:formerVt.point to:_currentTouchPoint];
            
            // move camera, if go near the border
            Camera* camera      = [Camera getObject];
            CGPoint camPoint    = [camera getPoint];
            //CGFloat camZoomX    = [camera getZoomX];
            
            CGSize camSize  = [[CCDirector sharedDirector] winSize];
            
            CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                                  camPoint.y - camSize.height*0.5f);
            
            CGPoint camToTouchDiff  = CGPointMake(_currentTouchPoint.x + camCenter.x,
                                                  _currentTouchPoint.y + camCenter.y );
            
            printf ("cam to touch diff (%f,%f)", camToTouchDiff.x, camToTouchDiff.y);
            printf ("\n");
            
            float camDifLength      = sqrtf(camToTouchDiff.x * camToTouchDiff.x +
                                                camToTouchDiff.y * camToTouchDiff.y);
            
            float cCamZoomX             = [[Camera getObject] getZoomX];
            float camDifLengthNoMove    = 180.0f / cCamZoomX;
            
            if ( camDifLength > camDifLengthNoMove )
            {
                float cOverBound        = camDifLength - camDifLengthNoMove;
                CGPoint camToTouchUnit  = CGPointMake(camToTouchDiff.x/camDifLength,
                                                      camToTouchDiff.y/camDifLength);
                
                float moveRatio = 1.9f * deltaTime;
                CGPoint moveVec = CGPointMake( (-1) * camToTouchUnit.x * cOverBound * moveRatio,
                                               (-1) * camToTouchUnit.y * cOverBound * moveRatio);
                
                [camera moveCameraByPoint:moveVec];
            }
            
        }
            break;
        case STATE_SELECT_ROUTE_ON_CALCEL_SELECTING:
        {
            CGPoint diffPoint   = CGPointMake(_nextVetexPoint.x - _currentTouchPoint.x,
                                              _nextVetexPoint.y - _currentTouchPoint.y);
            
            float cLength           = ABS(diffPoint.x) + ABS(diffPoint.y);
            float lengthInbound     = 120.0f;
            
            if ( cLength <= lengthInbound )
            {
                // selection success
                _currentState   = STATE_SELECT_ROUTE_MOVE_CAMERA;
                
                // hide menu route guide
                [_menuRouteGuide hideRouteTarget];
                [_menuRouteGuide hideLight];
                
                break;
            }
            
            // selection failed.
            [self _removeLastRoute];
            _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
            
            // hide menu route guide
            [_menuRouteGuide hideRouteTarget];
            [_menuRouteGuide hideLight];
        }
            break;
        case STATE_SELECT_ROUTE_MOVE_CAMERA:
        {   
            // set state
            _currentState   = STATE_SELECT_ROUTE_CAMERA_STOP;
        }
            break;
        case STATE_SELECT_ROUTE_CAMERA_STOP:
        {
            RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
            routeGraph.GetConnectedVertices(_currentConnectedVertices);
            TrVertex lastVertex     = routeGraph.GetVertexRoute().back();
            
            if ( _finishVertex.vertexId == lastVertex.vertexId )
            {
                _currentState   = STATE_SELECT_ROUTE_REACH_TARGET;
            }
            else
            {
                _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
            }
        }
            break;
        case STATE_SELECT_ROUTE_REACH_TARGET:
        {
            // generate paths
            [[World getObject] generatePathsFromRoute];
            
            RouteGraph& cRouteGraph     = [[World getObject] GetRouteGraph];
            vector<TrEdge> edgeRoute    = cRouteGraph.GetEdgeRoute();

            for ( int i=0; i<edgeRoute.size(); ++i)
            {
                TrEdge& cEdge    = edgeRoute[i];
                CCLOG (@"vertex start from: %d to: %d", cEdge.vertexStart, cEdge.vertexEnd);
            }
            
            CCLOG(@"Reach the Target!!!");
            _currentState   = STATE_SELECT_ROUTE_FINISH;   
        }
            break;
        case STATE_SELECT_ROUTE_FINISH:
        {
            [_menuSelectRoute hideAllButtons];
            return NO;
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
    if ( !
        (_currentState == STATE_SELECT_ROUTE_SELECT_ROUTE ||
         _currentState == STATE_SELECT_ROUTE_FINISH
         )
        )
        return NO;
    
    CGPoint location    = [touch locationInView:[touch view]];
    CGPoint touchPoint  = [[CCDirector sharedDirector] convertToGL:location];

    Camera* camera      = [Camera getObject];
    CGPoint camPoint    = [camera getPoint];
    CGFloat camZoomX    = [camera getZoomX];

    CGSize camSize  = [[CCDirector sharedDirector] winSize];
    
    CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                          camPoint.y - camSize.height*0.5f);
    
    CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                          camCenter.y + camSize.height*0.5f/camZoomX );
    
    CGPoint absPoint        = CGPointMake( touchPoint.x / camZoomX - viewPortPoint.x,
                                           touchPoint.y / camZoomX - viewPortPoint.y );
    
    printf ("touch point: (%f,%f)", absPoint.x, absPoint.y);
    printf ("\n");
    
    _currentTouchPoint  = absPoint;
    
    MenuSelectRoute* cMenuSelectRoute   = _menuSelectRoute;
    [cMenuSelectRoute checkActionByPoint:absPoint];
    
    // to move the screen
    _touchAtBegin           = [touch locationInView: [touch view]];
    _touchDeltaLastFrame    = CGPointMake(0.0f, 0.0f);
    
    // line plotter
    LinePlotter* linePlotter    = [[World getObject] getLinePlotter];
    //[linePlotter begineWithPoint:CGPointMake(-absPoint.x - 80.0f, -absPoint.y)];
    [linePlotter addPoint:CGPointMake(absPoint.x, absPoint.y)];
    //[linePlotter begineWithPoint:location];
    
    return YES;
}

- (void) onTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // set touching point AT move
    if ( _currentState == STATE_SELECT_ROUTE_ON_SELECTNG_ROUTE )
    {
        CGPoint location    = [touch locationInView:[touch view]];
        CGPoint touchPoint  = [[CCDirector sharedDirector] convertToGL:location];
        
        Camera* camera      = [Camera getObject];
        CGPoint camPoint    = [camera getPoint];
        CGFloat camZoomX    = [camera getZoomX];
        
        CGSize camSize  = [[CCDirector sharedDirector] winSize];
        
        CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                              camPoint.y - camSize.height*0.5f);
        
        CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                              camCenter.y + camSize.height*0.5f/camZoomX );
        
        CGPoint absPoint        = CGPointMake( touchPoint.x / camZoomX - viewPortPoint.x,
                                              touchPoint.y / camZoomX - viewPortPoint.y );
        
        _currentTouchPoint  = absPoint;
        
        // line plotter
        LinePlotter* linePlotter    = [[World getObject] getLinePlotter];
        //[linePlotter addPoint:CGPointMake(-absPoint.x - 80.0f, -absPoint.y)];
        [linePlotter addPoint:CGPointMake(absPoint.x, absPoint.y)];
        //[linePlotter begineWithPoint:location];
    }
    
    if (
        (_currentState == STATE_SELECT_ROUTE_SELECT_ROUTE ||
         _currentState == STATE_SELECT_ROUTE_FINISH
         )
        )
    {
        CGFloat zoomX   = [[Camera getObject] getZoomX];
        
        // cal..
        CGPoint touchPoint  = [touch locationInView: [touch view]];
        CGPoint touchDelta  = CGPointMake((touchPoint.x - _touchAtBegin.x) / zoomX ,
                                          (touchPoint.y - _touchAtBegin.y) / zoomX );
        CGPoint vecMoveCam  = CGPointMake(touchDelta.x - _touchDeltaLastFrame.x,
                                          touchDelta.y - _touchDeltaLastFrame.y);
        _touchDeltaLastFrame    = touchDelta;
        
        // move cam
        CGPoint vecMoveCamMod  = CGPointMake(vecMoveCam.x, -vecMoveCam.y);
        [[Camera getObject] moveCameraByPoint:vecMoveCamMod];
    }
    
}

- (void) onTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // line plotter
    LinePlotter* linePlotter    = [[World getObject] getLinePlotter];
    [linePlotter clear];
    
    if ( _currentState == STATE_SELECT_ROUTE_ON_SELECTNG_ROUTE )
    {
        CGPoint location    = [touch locationInView:[touch view]];
        CGPoint touchPoint  = [[CCDirector sharedDirector] convertToGL:location];
        
        Camera* camera      = [Camera getObject];
        CGPoint camPoint    = [camera getPoint];
        CGFloat camZoomX    = [camera getZoomX];
        
        CGSize camSize  = [[CCDirector sharedDirector] winSize];
        
        CGPoint camCenter       = CGPointMake(camPoint.x - camSize.width*0.5f,
                                              camPoint.y - camSize.height*0.5f);
        
        CGPoint viewPortPoint   = CGPointMake(camCenter.x + camSize.width*0.5f/camZoomX,
                                              camCenter.y + camSize.height*0.5f/camZoomX );
        
        CGPoint absPoint        = CGPointMake( touchPoint.x / camZoomX - viewPortPoint.x,
                                              touchPoint.y / camZoomX - viewPortPoint.y );
        
        _currentTouchPoint  = absPoint;
        
        _currentState   = STATE_SELECT_ROUTE_ON_CALCEL_SELECTING;
    }
    
}

- (void) onGetStringMessage: (NSString*) message
{
    // cancel route message
    if ( [message isEqualToString:@"remove_back"] )
    {
        [self _removeLastRoute];
        _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
        
        // hide menu route guide
        [_menuRouteGuide hideRouteTarget];
        [_menuRouteGuide hideLight];
    }
}

#pragma mark - MenuSelectRoute action

- (void) onTouchButtonAtId: (int) buttonId
{
    // next vertex
    TrVertex nextVertex     = _currentConnectedVertices[buttonId];
    
    RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
    routeGraph.PushVertex(nextVertex);
    
    _hasSelectedRouteThisPoint  = YES;
    
    // set next selecting point
    _nextVetexPoint         = nextVertex.point;
}

#pragma mark - PIMPL

- (void) _removeLastRoute
{
    // remove last route
    RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
    if ( routeGraph.GetVertexRoute().size() <= 1 )
        return;
    
    routeGraph.RemoveBackRoute();
    routeGraph.GetConnectedVertices(_currentConnectedVertices);
    
    [[World getObject] generatePathsFromRoute];
    
    _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
}

- (void) _setMenuButtonAtLastVertex
{
    // load select route button
    MenuSelectRoute* menuSelectRoute    = _menuSelectRoute;
    RouteGraph& routeGraph  = [[World getObject] GetRouteGraph];
    routeGraph.GetConnectedVertices(_currentConnectedVertices);
    TrVertex lastVertex        = routeGraph.GetVertexRoute().back();
    
    int connectedSize   = _currentConnectedVertices.size();
    [menuSelectRoute loadButtonAtPoint:lastVertex.point
                            routeCount:connectedSize
                             rootLayer:layer];
    
    [menuSelectRoute setActionObject:self];
    
    [menuSelectRoute hideAllButtons];
    for ( int i=0; i<connectedSize; ++i)
    {
        // get edge from that point
        RouteGraph& cRouteGraph = [[World getObject] GetRouteGraph];
        int cConnectedVertexId  = _currentConnectedVertices[i].vertexId;
        
        TrEdge cEdge    = cRouteGraph.GetEdgeFromVertexId(lastVertex.vertexId,
                                                          cConnectedVertexId);
        
        if ( cEdge.subPoints.size() > 0)
        {
            CGPoint cPoint = [UtilVec convertVecIfRetina:cEdge.subPoints[0]];
            [menuSelectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
        }
        else
        {
            // currentConnectedVertices and selectRoute are paired by id
            CGPoint cPoint = [UtilVec convertVecIfRetina:_currentConnectedVertices[i].point];
            [menuSelectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
        }
        
        // is this path already has route
        vector<TrVertex> vertexRoute    = cRouteGraph.GetVertexRoute();
        for (int cv=0; cv<vertexRoute.size(); ++cv)
        {
            TrVertex cVertex    = vertexRoute[cv];
            if ( cVertex.vertexId == cConnectedVertexId )
            {
                break;
            }
        }
        
        // set menu
        [menuSelectRoute showButtonAtIndex:i];
    }
}

@end
