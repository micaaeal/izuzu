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

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
RouteGraph::RouteGraph()
{
    _trGraphPtr = NULL;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
RouteGraph::~RouteGraph()
{
    _trGraphPtr = NULL;
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
    _edgeRoute.pop_back();
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

