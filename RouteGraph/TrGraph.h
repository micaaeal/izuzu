//
//  RouteGraphData.h
//  RouteGraph
//
//  Created by Adawat Chanchua on 9/24/55 BE.
//  Copyright (c) 2555 Adawat Chanchua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vector>

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
struct TrVertex
{
    int vertexId;
    CGPoint point;
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
struct TrEdge
{
    int vertexStart;
    int vertexEnd;
    std::vector<CGPoint> subPoints;
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
struct TrAdjacencyMatrix
{
    int length;
    std::vector<bool>   edgeFlages;
    std::vector<int>    edgeIndices;
};

// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
class TrGraph
{
 
public:
    
    TrGraph();
    ~TrGraph();
    
    void Start();
    void Shutdown();
    
    TrAdjacencyMatrix&        GetAdjacencyMatrixRef();
    TrEdge*                   GetEdgeRef(int amX, int amY);
    std::vector<TrVertex>&    GetVerticesRef();
    std::vector<TrEdge>&      GetEdgesRef();
    void                      GetAdjacencyVertices(TrVertex& vertex,
                                                         std::vector<TrVertex>& outVertices);
    
    void PrintAdJacencyMatrix();
    
private:
    
    void _InitAdjacencyMatrix(TrAdjacencyMatrix& adjacencyMatrixRef);
    void _InitVertices(std::vector<TrVertex>& vertices);
    void _InitEdges(std::vector<TrEdge>& edges);
    void _InitAdjacencyMatrixEdgeIndice(TrAdjacencyMatrix& adjacencyMatrixRef, std::vector<TrEdge>& edges);
    
    TrAdjacencyMatrix       _adjacencyMatrix;
    std::vector<TrEdge>     _edges;
    std::vector<TrVertex>   _vertices;
    
};
