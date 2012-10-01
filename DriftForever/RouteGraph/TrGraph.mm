//
//  RouteGraphData.m
//  RouteGraph
//
//  Created by Adawat Chanchua on 9/24/55 BE.
//  Copyright (c) 2555 Adawat Chanchua. All rights reserved.
//

#include "TrGraph.h"
#include <stdio.h>
#include <math.h>

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
TrGraph::TrGraph()
{
    _adjacencyMatrix.length = 0;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
TrGraph::~TrGraph()
{
    _adjacencyMatrix.length = 0;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::Start()
{
    // init vertices
    _InitAdjacencyMatrix(_adjacencyMatrix);
    _InitVertices(_vertices);
    _InitEdges(_edges);
    _InitAdjacencyMatrixEdgeIndice(_adjacencyMatrix, _edges);
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::Shutdown()
{
    // clean adjacency matrix
    int arrayCount    = _adjacencyMatrix.edgeFlages.size();
    for (int i=0; i<arrayCount; ++i)
    {
        _adjacencyMatrix.edgeFlages[i]   = 0;
    }
    arrayCount    = _adjacencyMatrix.edgeIndices.size();
    for (int i=0; i<arrayCount; ++i)
    {
        _adjacencyMatrix.edgeIndices[i]   = 0;
    }
    
    // clear route edge
    _edges.clear();
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
TrAdjacencyMatrix& TrGraph::GetAdjacencyMatrixRef()
{
    return _adjacencyMatrix;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrVertex>& TrGraph::GetVerticesRef()
{
    return _vertices;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
TrEdge* TrGraph::GetEdgeRef(int amX, int amY)
{
    const int length    = _adjacencyMatrix.length;
    
    if ( amX >= length )
        return NULL;
    if ( amY >= length )
        return NULL;
    
    // retrieve edge
    int index               = length * amX + amY;
    int cEdgeIndex          = _adjacencyMatrix.edgeIndices[index];
    TrEdge* cEdgePtr        = &_edges[cEdgeIndex];
    return cEdgePtr;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
std::vector<TrEdge>&  TrGraph::GetEdgesRef()
{
    return _edges;
}

void TrGraph::GetAdjacencyVertices(TrVertex& vertex, std::vector<TrVertex>& outVertices)
{
    const int length    = _adjacencyMatrix.length;
    
    outVertices.clear();
    
    const int searchCount           = length;
    int vertexId                    = vertex.vertexId;
    int adjacencyMatrixInitIndex    = vertexId * length;
    int adjacencyMatrixLastIndex    = adjacencyMatrixInitIndex + searchCount - 1;
    
    for (int i=adjacencyMatrixInitIndex; i<=adjacencyMatrixLastIndex; ++i)
    {
        bool isAdjacent = _adjacencyMatrix.edgeFlages[i];
        
        if ( ! isAdjacent )
            continue;
        
        int adjacencyVertexIndex    = i % length;

        TrVertex cVertex    = _vertices[adjacencyVertexIndex];
        outVertices.push_back(cVertex);
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::_InitAdjacencyMatrix(TrAdjacencyMatrix &adjacencyMatrixRef)
{
    // load config file
    NSString* configFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"adjacency_matrix_config.plist"];
    NSArray* configArray    = [[NSArray alloc] initWithContentsOfFile:configFullPath];
    
    adjacencyMatrixRef.length   = sqrt(configArray.count);
    
    // load adjacency matrix to memory
    for (NSString* cValue in configArray)
    { 
        _adjacencyMatrix.edgeFlages.push_back(cValue.intValue);
        _adjacencyMatrix.edgeIndices.push_back(-1);
    }
    
    [configArray release];
    configArray = nil;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::_InitVertices(std::vector<TrVertex>& vertices)
{
    // load config file
    NSString* configFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"vertices_config.plist"];
    NSArray* configArray    = [[NSArray alloc] initWithContentsOfFile:configFullPath];
    
    int cVertexId   = 0;
    for (NSDictionary* cVertexDict in configArray)
    {
        NSString* x = [cVertexDict objectForKey:@"x"];
        NSString* y = [cVertexDict objectForKey:@"y"];
        TrVertex cVertex;
        cVertex.vertexId    = cVertexId;
        cVertex.point       = CGPointMake(x.floatValue, y.floatValue);
        vertices.push_back(cVertex);
        ++cVertexId;
    }
    
    [configArray release];
    configArray = nil;
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::_InitEdges(std::vector<TrEdge>& edges)
{
    // load config file
    NSString* configFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"edges_config.plist"];
    NSArray* configArray    = [[NSArray alloc] initWithContentsOfFile:configFullPath];
    
    for (NSDictionary* cEdgeDict in configArray)
    {
        NSString* vertex_start  = [cEdgeDict objectForKey:@"vertex_start"];
        NSString* vertex_end    = [cEdgeDict objectForKey:@"vertex_end"];
        
        TrEdge cEdge;
        cEdge.vertexStart  = vertex_start.intValue;
        cEdge.vertexEnd    = vertex_end.intValue;
        
        NSArray* subpoints  = [cEdgeDict objectForKey:@"sub_points"];
        for (NSDictionary* cSubPointDict in subpoints)
        {
            NSString* x  = [cSubPointDict objectForKey:@"x"];
            NSString* y  = [cSubPointDict objectForKey:@"y"];
            
            cEdge.subPoints.push_back(CGPointMake(x.floatValue, y.floatValue));
        }
        
        edges.push_back(cEdge);
    }
    
    [configArray release];
    configArray = nil;
 }

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::_InitAdjacencyMatrixEdgeIndice(TrAdjacencyMatrix& adjacencyMatrixRef,
                                    std::vector<TrEdge>& edges)
{
    // init edge indices
    const int arrayCount    = adjacencyMatrixRef.edgeFlages.size();
    for (int i=0; i<arrayCount; ++i)
    {
        bool cHasEdge   = adjacencyMatrixRef.edgeFlages[i];
        
        if ( ! cHasEdge )
            continue;
        
        int vertexStart = i / adjacencyMatrixRef.length;
        int vertexEnd   = i % adjacencyMatrixRef.length;
        
        for (int j=0; j<edges.size(); ++j)
        {
            TrEdge& cEdge   = edges[j];
            
            if ( cEdge.vertexStart != vertexStart )
                continue;
            if ( cEdge.vertexEnd != vertexEnd )
                continue;
            
            adjacencyMatrixRef.edgeIndices[i]  = j;
        }
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::PrintAdJacencyMatrix()
{
    const int arrayCount    = _adjacencyMatrix.edgeFlages.size();
    const int length        = _adjacencyMatrix.length;
    
    // print edge flages
    printf ("\n");
    printf ("edge flags:");
    printf ("\n");
    for (int i=0; i<arrayCount; ++i)
    {
        bool hasAdjacentVertex    = _adjacencyMatrix.edgeFlages[i];
        
        if ( i%length == 0 )
            printf ("\n");
        printf ("| ");
        printf ("%s", hasAdjacentVertex? "1" : "-");
    }

    // print edge indices
    printf ("\n");
    printf ("edge indices:");
    printf ("\n");
    for (int i=0; i<arrayCount; ++i)
    {
        int cEdgeIndex    = _adjacencyMatrix.edgeIndices[i];
        
        if ( i%length == 0 )
            printf ("\n");
        
        printf ("| ");
        if ( cEdgeIndex == -1 )
            printf ("-");
        else
            printf ("%d", cEdgeIndex);
    }
}

