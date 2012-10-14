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

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
enum STATE_SELECT_ROUTE
{
    STATE_SELECT_ROUTE_NONE = 0,
    
    STATE_SELECT_ROUTE_START,
    STATE_SELECT_ROUTE_LOAD_ROUTE,
    STATE_SELECT_ROUTE_SELECT_ROUTE,
    STATE_SELECT_ROUTE_MOVE_CAMERA,
    STATE_SELECT_ROUTE_CAMERA_STOP,
    STATE_SELECT_ROUTE_REACH_TARGET,
    STATE_SELECT_ROUTE_FINISH,
    
    STATE_SELECT_ROUTE_COUNT,
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- 
@interface StateSelectRoute()

@property (assign) vector<TrVertex>    _vertexRoute;
@property (assign) vector<TrEdge>      _edgeRoute;
@property (assign) MenuSelectRoute*    _currentMenuSelectRoute;
@property (assign) NSMutableArray*     _menuSelectRouteArray;
@property (assign) TrVertex            _currentVertex;
@property (assign) TrVertex            _startVertex;
@property (assign) TrVertex            _finishVertex;
@property (assign) vector<TrVertex>    _currentConnectedVertices;

@property (assign) BOOL                _hasSelectedRouteThisPoint;
@property (assign) TrVertex            _nextVertex;
@property (assign) STATE_SELECT_ROUTE  _currentState;

@property (retain) Mission*            _currentMission;

@end

@implementation StateSelectRoute
@synthesize layer;
@synthesize _vertexRoute;
@synthesize _edgeRoute;
@synthesize _currentMenuSelectRoute;
@synthesize _menuSelectRouteArray;
@synthesize _currentVertex;
@synthesize _startVertex;
@synthesize _finishVertex;
@synthesize _currentConnectedVertices;
@synthesize _hasSelectedRouteThisPoint;
@synthesize _nextVertex;
@synthesize _currentState;
@synthesize _currentMission;

- (void) onStart
{
    // vers
    _currentState   = STATE_SELECT_ROUTE_NONE;
    _hasSelectedRouteThisPoint  = NO;
    
    // create select route array
    _menuSelectRouteArray   = [[NSMutableArray alloc] init];
    
    // clear routeGraph
    RouteGraph& routeGraph  = [World GetRouteGraph];
    routeGraph.ClearRoute();
}

- (void) onFinish
{
    // clear menu route
    for (int i=0; i<_menuSelectRouteArray.count; ++i)
    {
        MenuSelectRoute* cMenu  = [_menuSelectRouteArray objectAtIndex:i];
        
        for (int j=0; j<cMenu.routeCount; ++j)
        {
            [cMenu hideButtonAtIndex:j];
        }
    }
    
    [_menuSelectRouteArray release];
    _menuSelectRouteArray   = nil;
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
            // set currentVertexPtr from the @Mission
            int cMissionCode    = [Mission getCurrentMissionCode];
            Mission* cMission   = [Mission GetMissionFromCode:cMissionCode];
            _currentMission = cMission;
            
            // all about route graph
            RouteGraph& routeGraph  = [World GetRouteGraph];
            vector<TrVertex> allVertices    = routeGraph.GetAllVertices();
            _startVertex    = allVertices[[_currentMission GetStartVertex]];
            _finishVertex   = allVertices[[_currentMission GetEndVertex]];
            _currentVertex  = _startVertex;
            
            Camera* cam = [Camera getObject];
            CGPoint camPoint = [UtilVec convertVecIfRetina:_currentVertex.point];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [cam setCameraToPoint:camPoint];
            
            routeGraph.PushVertex(_currentVertex);
            
            // set state
            _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;
        }
            break;
        case STATE_SELECT_ROUTE_LOAD_ROUTE:
        {
            // manipulate route graph
            RouteGraph& routeGraph  = [World GetRouteGraph];
            routeGraph.GetConnectedVertices(_currentConnectedVertices);

            // set select route
            
            // @WARNING risk of dynamic allocation here
            MenuSelectRoute* selectRoute    = [[MenuSelectRoute alloc] init];
            // @TODO more resource loading checking here
            CGPoint buttonRefPoint  = [UtilVec convertVecIfRetina:_currentVertex.point];
            [selectRoute loadButtonAtPoint:buttonRefPoint
                                routeCount:_currentConnectedVertices.size()
                                 rootLayer:layer];
            [selectRoute setActionObject:self];
            
            int connectedSize   = _currentConnectedVertices.size();
            for ( int i=0; i<connectedSize; ++i)
            {
                RouteGraph& cRouteGraph = [World GetRouteGraph];
                int cConnectedVertexId  = _currentConnectedVertices[i].vertexId;
                
                TrEdge cEdge    = cRouteGraph.GetEdgeFromVertexId(_currentVertex.vertexId,
                                                                  cConnectedVertexId);
                
                if ( cEdge.subPoints.size() > 0)
                {
                    CGPoint cPoint = [UtilVec convertVecIfRetina:cEdge.subPoints[0]];
                    [selectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
                }
                else
                {
                    // currentConnectedVertices and selectRoute are paired by id
                    CGPoint cPoint = [UtilVec convertVecIfRetina:_currentConnectedVertices[i].point];
                    [selectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
                }
                
                // search in vertex
                BOOL alreadyHasRoute    = NO;
                vector<TrVertex> vertexRoute    = cRouteGraph.GetVertexRoute();
                for (int cv=0; cv<vertexRoute.size(); ++cv)
                {
                    TrVertex cVertex    = vertexRoute[cv];
                    if ( cVertex.vertexId == cConnectedVertexId )
                    {
                        alreadyHasRoute = YES;
                        break;
                    }
                }
                
                // set button state
                if ( alreadyHasRoute )
                {
                    [selectRoute setButtonStateToRed:i];
                }
                else{
                    [selectRoute setButtonStateToGreen:i];
                }
            }
            
            _currentMenuSelectRoute = selectRoute;
            
            // add to array to retain selectRoute
            [_menuSelectRouteArray addObject:selectRoute];
            
            [selectRoute release];
            selectRoute = nil;
            
            // set flags
            _hasSelectedRouteThisPoint  = NO;
            
            // set state
            _currentState   = STATE_SELECT_ROUTE_SELECT_ROUTE;
        }
            break;
        case STATE_SELECT_ROUTE_SELECT_ROUTE:
        {
            if ( _hasSelectedRouteThisPoint )
            {
                _currentState   = STATE_SELECT_ROUTE_MOVE_CAMERA;
            }
        }
            break;
        case STATE_SELECT_ROUTE_MOVE_CAMERA:
        {
            // varp to the next point
            RouteGraph& cRouteGraph = [World GetRouteGraph];
            TrEdge cEdge    = cRouteGraph.GetEdgeFromVertexId(_currentVertex.vertexId,
                                                              _nextVertex.vertexId);
            
            _currentVertex  = _nextVertex;
            cRouteGraph.PushVertex(_currentVertex);
            
            // move camera
            Camera* cam = [Camera getObject];
            CGPoint camPoint = [UtilVec convertVecIfRetina:_currentVertex.point];
            CGSize winSize  = [[CCDirector sharedDirector] winSize];
            camPoint.x -= (winSize.width * 0.5f);
            camPoint.y -= (winSize.height * 0.5f);
            [cam setCameraToPoint:camPoint];
            
            // set state
            _currentState   = STATE_SELECT_ROUTE_CAMERA_STOP;
        }
            break;
        case STATE_SELECT_ROUTE_CAMERA_STOP:
        {
            if ( _finishVertex.vertexId == _currentVertex.vertexId )
            {
                _currentState  = STATE_SELECT_ROUTE_REACH_TARGET;
            }
            else
            {
                _currentState   = STATE_SELECT_ROUTE_LOAD_ROUTE;   
            }
        }
            break;
        case STATE_SELECT_ROUTE_REACH_TARGET:
        {
            RouteGraph& cRouteGraph     = [World GetRouteGraph];
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
    
    [_currentMenuSelectRoute checkActionByPoint:absPoint];
    
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
    // cancel route message
    if ( [message isEqualToString:@"cancel"] )
    {
        /*
        // hide menu
        for (int i=0; i<_currentMenuSelectRoute.routeCount; ++i)
        {
            [_currentMenuSelectRoute hideButtonAtIndex:i];
        }
        
        // remove node
        RouteGraph& cRouteGraph = [World GetRouteGraph];
        cRouteGraph.RemoveBackRoute();
        */
    }
}

#pragma mark - MenuSelectRoute action

- (void) onTouchButtonAtId: (int) buttonId isGreen: (BOOL) isGreen
{
    if ( ! isGreen )
        return;

    // hide all buttons
    for (int i=0; i<_currentMenuSelectRoute.routeCount; ++i)
    {
        if ( [_currentMenuSelectRoute isThisButtonGreen:i] )
        {
            [_currentMenuSelectRoute hideButtonAtIndex:i];   
        }
    }
    
    // turn button to red
    [_currentMenuSelectRoute showButtonAtIndex:buttonId];
    [_currentMenuSelectRoute setButtonStateToRed:buttonId];
    
    // next vertex
    _nextVertex         = _currentConnectedVertices[buttonId];
    _hasSelectedRouteThisPoint  = YES;
}

@end
