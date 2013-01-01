//
//  RouteGraph.m
//  RouteGraph
//
//  Created by Adawat Chanchua on 9/24/55 BE.
//  Copyright (c) 2555 Adawat Chanchua. All rights reserved.
//

#import "RouteGraph.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

using namespace std;

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
RouteGraph::RouteGraph()
{
    _trGraphPtr = NULL;
    _hasCancelState = false;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
RouteGraph::~RouteGraph()
{
    _trGraphPtr = NULL;
    _hasCancelState = false;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void RouteGraph::Start()
{
    _trGraphPtr = new TrGraph();
    _trGraphPtr->Start();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void RouteGraph::Shutdown()
{
    _trGraphPtr->Shutdown();
    
    delete _trGraphPtr;
    _trGraphPtr = NULL;
    
    _verticesRoute.clear();
    _edgeRoute.clear();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void RouteGraph::PushVertex(TrVertex& vertex)
{
    TrVertex cVertex    = vertex;
    _verticesRoute.push_back(cVertex);
    
    CCLOG(@"push vertex with id: %d", vertex.vertexId);
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void RouteGraph::GetConnectedVertices(std::vector<TrVertex>& outVertices)
{
    TrVertex& vertexBack    = _verticesRoute.back();
    _trGraphPtr->GetAdjacencyVertices(vertexBack, outVertices);
}

TrEdge RouteGraph::GetEdgeFromVertexId(int initVertexId, int endVertexId)
{
    return *_trGraphPtr->GetEdgeRef(initVertexId, endVertexId);
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrVertex> RouteGraph::GetVertexRoute()
{
    return _verticesRoute;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void    RouteGraph::ClearRoute()
{
    _verticesRoute.clear();
    _edgeRoute.clear();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void    RouteGraph::RemoveBackRoute()
{
    _verticesRoute.pop_back();
    // re-calculate edge route
    GetEdgeRoute();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrEdge> RouteGraph::GetEdgeRoute()
{
    int count   = _verticesRoute.size();
    
    _edgeRoute.clear();
    
    for (int i=0; i<count; ++i)
    {
        if ( i == 0 )
            continue;
        
        TrVertex& tVertex       = _verticesRoute[i];
        TrVertex& iVertex       = _verticesRoute[i-1];
        const TrEdge* cEdge     = _trGraphPtr->GetEdgeRef(iVertex.vertexId, tVertex.vertexId);
        _edgeRoute.push_back(*cEdge);
    }
    
    return _edgeRoute;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrVertex> RouteGraph::GetAllVertices()
{
    return _trGraphPtr->GetVerticesRef();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void RouteGraph::PrintVertices(std::vector<TrVertex>& vertices)
{
    for (int i=0; i<vertices.size(); ++i)
    {
        printf ("\n");
        printf (" -> #%d", vertices[i].vertexId);
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrEdge> RouteGraph::GetAllEdges()
{
    return _trGraphPtr->GetEdgesRef();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
double RouteGraph::GetRouteLength()
{
    vector<TrEdge> edgeRoute    = GetEdgeRoute();
    vector<TrVertex>& vertices  = _trGraphPtr->GetVerticesRef();
    _edgeRoutePath.clear();
    _edgeRouteDistance.clear();
    
    double routeLength  = 0.0f;
    for ( int i=0; i<edgeRoute.size(); ++i )
    {
        TrEdge& cEdge    = edgeRoute[i];
        TrVertex vertexStart    = vertices[cEdge.vertexStart];
        TrVertex vertexEnd      = vertices[cEdge.vertexEnd];
        
        // compose path of each edge subpoints
        vector<CGPoint> routePathThisPeriod;
        routePathThisPeriod.push_back(vertexStart.point);
        _edgeRoutePath.push_back(vertexStart.point);
        for (int j=0; j<cEdge.subPoints.size(); ++j)
        {
            routePathThisPeriod.push_back(cEdge.subPoints[j]);
            _edgeRoutePath.push_back(cEdge.subPoints[j]);
        }
        routePathThisPeriod.push_back(vertexEnd.point);
        _edgeRoutePath.push_back(vertexEnd.point);
        
        // calculate distance from all of subpoints
        for (int j=0; j<routePathThisPeriod.size(); ++j)
        {
            if ( j == 0 )
            {
                _edgeRouteDistance.push_back(0.0f);
                continue;
            }
            
            double deltaX   = routePathThisPeriod[j].x - routePathThisPeriod[j-1].x;
            double deltaY   = routePathThisPeriod[j].y - routePathThisPeriod[j-1].y;
            
            double distance = sqrtf( deltaX*deltaX + deltaY*deltaY );
            
            routeLength += distance;
            
            // set distance route
            _edgeRouteDistance.push_back(routeLength);
        }
    }
    
    printf ("\n");
    printf ("_edgeRoutePath.size: %d", (int)_edgeRoutePath.size());
    printf ("\n");
    printf ("_edgeRouteDistance.size: %d", (int)_edgeRouteDistance.size());
    printf ("\n");
    
//    for ( int i=0; i<_edgeRouteDistance.size(); ++i )
//    {
//        printf ("c distance: %lf", _edgeRouteDistance[i]);
//        printf ("\n");
//    }
    
    return routeLength;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
CGPoint RouteGraph::GetPointByNormalizeValue(double normValue, double& outExpectedDistance)
{
    // check validity
    if ( normValue < 0.0f || normValue > 1.0f )
        return CGPointMake(0.0f, 0.0f);
    
    double expectedDistance    = _edgeRouteDistance.back() * normValue;
    outExpectedDistance = expectedDistance;
    
    // search index to meet
    int expectedIndex   = -1;
    for ( int i=0; i<_edgeRouteDistance.size(); ++i)
    {
        if ( _edgeRouteDistance[i] >= expectedDistance )
        {
            expectedIndex   = i;
            break;
        }
    }
    
//    printf ("\n");
//    printf ("expect expectedDistance: %f", expectedDistance);
//    printf ("\n");
//    printf ("with distance at index: %f", _edgeRouteDistance[expectedIndex]);
//    printf ("\n");
    
    // in case serious unexpected value
    if ( expectedIndex == -1 )
    {
        CCLOG(@"expected index is out of expected bound!!");
        
//        printf ("\n");
//        printf ("with expect expectedDistance: %f", expectedDistance);
//        printf ("\n");
//        printf ("from max distance: %f", _edgeRouteDistance.back());
//        printf ("\n");
        
        return CGPointMake(0.0f, 0.0f);
    }
    
//    printf ("expected index: %d of size %d", expectedIndex, (int)_edgeRouteDistance.size());
//    printf ("\n");
    
    // calculate point
    double startDistanceOfBound = 0.0f;
    double endDistanceOfBound   = 0.0f;
    CGPoint startPointOfBound;
    CGPoint endPointOfBound     = _edgeRoutePath[expectedIndex];
    if ( expectedIndex > 0 )
    {
        startDistanceOfBound    = _edgeRouteDistance[expectedIndex-1];
        startPointOfBound       = _edgeRoutePath[expectedIndex-1];
    }
    else
    {
        startDistanceOfBound    = _edgeRouteDistance[0];
        startPointOfBound   = _edgeRoutePath[0];
    }
    endDistanceOfBound = _edgeRouteDistance[expectedIndex] - startDistanceOfBound;
    
    double deltaX   = endPointOfBound.x - startPointOfBound.x;
    double deltaY   = endPointOfBound.y - startPointOfBound.y;
    double deltaDistance              = endDistanceOfBound - startDistanceOfBound;
    double expectedDistanceOfBound    = expectedDistance - startDistanceOfBound;
    
    if ( deltaDistance == 0.0f )
    {
//        printf ("deltaDistance is absolute zero!");
//        printf ("\n");
        
        return CGPointMake(startPointOfBound.x, startPointOfBound.y);
    }
    
    double targetX  = deltaX * expectedDistanceOfBound / deltaDistance;
    double targetY  = deltaY * expectedDistanceOfBound / deltaDistance;

//    printf ("delta point: (%f,%f)", targetX, targetY);
//    printf ("\n");
    
    targetX = targetX + startPointOfBound.x;
    targetY = targetY + startPointOfBound.y;
    
    return CGPointMake(targetX, targetY);
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
bool    RouteGraph::GetHasCancelState()
{
    return _hasCancelState;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void    RouteGraph::SetHasCancelState(bool flag)
{
    _hasCancelState = flag;
}

