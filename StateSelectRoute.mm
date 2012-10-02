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

- (void) onStart
{
    // vers
    _currentState   = STATE_SELECT_ROUTE_NONE;
    _hasSelectedRouteThisPoint  = NO;
    
    // create select route array
    _menuSelectRouteArray   = [[NSMutableArray alloc] init];
}

- (void) onFinish
{
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
            RouteGraph& routeGraph  = [World GetRouteGraph];
            vector<TrVertex> allVertices    = routeGraph.GetAllVertices();
            _startVertex    = allVertices[1];
            _finishVertex   = allVertices[3];
            _currentVertex      = _startVertex;
            
            Camera* cam = [Camera getObject];
            [cam setCameraToPoint:_currentVertex.point];

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
            
            // @WARNING risk dynamic allocation here
            MenuSelectRoute* selectRoute    = [[MenuSelectRoute alloc] init];
            // @TODO more resource loading checking here
            [selectRoute loadButtonAtPoint:_currentVertex.point
                                routeCount:_currentConnectedVertices.size()
                                 rootLayer:layer];
            [selectRoute setActionObject:self];
            
            for ( int i=0; i<_currentConnectedVertices.size(); ++i)
            {
                RouteGraph& cRouteGraph = [World GetRouteGraph];
                TrEdge cEdge    = cRouteGraph.GetEdgeFromVertexId(_currentVertex.vertexId,
                                                                  _currentConnectedVertices[i].vertexId);
                
                if ( cEdge.subPoints.size() > 0)
                {
                    CGPoint cPoint  = cEdge.subPoints[0];
                    [selectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
                }
                else
                {
                    // currentConnectedVertices and selectRoute are paired by id
                    CGPoint cPoint  = _currentConnectedVertices[i].point;
                    [selectRoute setRouteButtonDirectTo:cPoint buttonIndex:i];
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
            
            Camera* cam = [Camera getObject];
            [cam setCameraToPoint:_currentVertex.point];
            
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
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGFloat touchX      = location.x;
    CGFloat touchY      = location.y;
    
    float centerX, centerY, centerZ;
    float eyeX, eyeY, eyeZ;
    [layer.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
    [layer.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
    
    CGFloat touchCameraX    = touchX + centerX;
    CGFloat touchCameraY    = touchY + centerY;

    CGPoint touchingPoint  = CGPointMake(touchCameraX, touchCameraY);
    
    [_currentMenuSelectRoute checkActionByPoint:touchingPoint];
    return YES;
}

- (void) onTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) onTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

#pragma mark - MenuSelectRoute action

- (void) onTouchButtonAtId:(int)buttonId
{
    _nextVertex = _currentConnectedVertices[buttonId];
    _hasSelectedRouteThisPoint  = YES;
}

@end
