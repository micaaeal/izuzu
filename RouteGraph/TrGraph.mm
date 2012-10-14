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
    
    PrintAdJacencyMatrix();
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
    const int length    = sqrtf( _adjacencyMatrix.length );
    
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
    const int length    = sqrtf(_adjacencyMatrix.length);
    
    outVertices.clear();
    
    const int searchCount           = length;
    int vertexId                    = vertex.vertexId;
    int adjacencyMatrixInitIndex    = vertexId * length;
    int adjacencyMatrixLastIndex    = adjacencyMatrixInitIndex + searchCount - 1;
    
    printf ("---- ---- ---- ----");
    printf ("\n");
    for (int i=adjacencyMatrixInitIndex; i<=adjacencyMatrixLastIndex; ++i)
    {
        bool isAdjacent = _adjacencyMatrix.edgeFlages[i];
        
        if ( ! isAdjacent )
            continue;
        
        int adjacencyVertexIndex    = i % length;

        TrVertex cVertex    = _vertices[adjacencyVertexIndex];
        outVertices.push_back(cVertex);
        
        printf ("current vertex id: %d", cVertex.vertexId);
        printf ("\n");
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::_InitAdjacencyMatrix(TrAdjacencyMatrix &adjacencyMatrixRef)
{
    /* // load config file
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
    /*/
    NSString* configFullPath    = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"adjacency_matrix_config.plist"];
    NSDictionary* configDict    = [[NSDictionary alloc] initWithContentsOfFile:configFullPath];
    
    int length       = ((NSString*)[configDict objectForKey:@"length"]).intValue;
    
    adjacencyMatrixRef.length   = length * length;
    
    // load adjacency matrix to memory
    for ( int i=0; i<adjacencyMatrixRef.length; ++i)
    {
        _adjacencyMatrix.edgeFlages.push_back(false);
        _adjacencyMatrix.edgeIndices.push_back(-1);
    }
    
    [configDict release];
    configDict = nil;
    /**/
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
    const int length        = sqrtf( _adjacencyMatrix.length );
    
    for (int i=0; i<edges.size(); ++i)
    {
        TrEdge& cEdge   = edges[i];
        
        int row = cEdge.vertexStart;
        int col = cEdge.vertexEnd;
        
        int index   = row * length + col;
        
        adjacencyMatrixRef.edgeFlages[index]    = 1;
        adjacencyMatrixRef.edgeIndices[index]   = i;
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void TrGraph::PrintAdJacencyMatrix()
{
    const int arrayCount    = _adjacencyMatrix.edgeFlages.size();
    const int length        = sqrtf( _adjacencyMatrix.length );
    
    // print edge flages
    printf ("\n");
    printf ("edge flags:");
    
    printf ("\n");
    for (int i=0; i<length; ++i)
    {
        if ( i<10 )
        {
            printf ("|");
            printf ("0%d", i);
            continue;
        }
        printf ("|");
        printf ("%d", i);
    }
    
    for (int i=0; i<arrayCount; ++i)
    {
        bool hasAdjacentVertex    = _adjacencyMatrix.edgeFlages[i];
        
        if ( i%length == 0 )
            printf ("\n");
        
        printf ("|");
        printf ("%s", hasAdjacentVertex? "||" : "--");
    }
    
    // print edge indices
    printf ("\n");
    printf ("edge indices:");
    
    printf ("\n");
    for (int i=0; i<length; ++i)
    {
        if ( i<10 )
        {
            printf ("|");
            printf ("0%d", i);
            continue;
        }
        printf ("|");
        printf ("%d", i);
    }
    
    for (int i=0; i<arrayCount; ++i)
    {
        int cEdgeIndex    = _adjacencyMatrix.edgeIndices[i];
        
        if ( i%length == 0 )
            printf ("\n");
        
        if ( cEdgeIndex == -1 )
        {
            printf ("|");
            printf ("--");
        }
        else
        {
            printf ("|");
            if ( cEdgeIndex < 10 )
            {
                printf ("0%d", cEdgeIndex);
            }
            else
            {
                printf ("%d", cEdgeIndex);
            }
        }
    }
}

