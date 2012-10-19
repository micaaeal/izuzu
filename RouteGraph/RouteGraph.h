//
//  RouteGraph.h
//  RouteGraph
//
//  Created by Adawat Chanchua on 9/24/55 BE.
//  Copyright (c) 2555 Adawat Chanchua. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "TrGraph.h"

class RouteGraph
{
    
public:
    RouteGraph();
    ~RouteGraph();
    
    void Start();
    void Shutdown();
    
    void PushVertex(TrVertex& vertex);
    void GetConnectedVertices(std::vector<TrVertex>& outVertices);
    TrEdge GetEdgeFromVertexId(int initVertexId, int endVertexId);
    
    std::vector<TrVertex>   GetVertexRoute();
    std::vector<TrEdge>     GetEdgeRoute();
    
    void    ClearRoute();
    void    RemoveBackRoute();
    
    std::vector<TrVertex> GetAllVertices();
    void PrintVertices(std::vector<TrVertex>& vertices);
    
    double  GetRouteLength();
    CGPoint GetPointByNormalizeValue(double normValue, double& outExpectedDistance);
    
    bool    GetHasCancelState();
    void    SetHasCancelState(bool flag);
        
private:
    std::vector<TrVertex>   _verticesRoute;
    std::vector<TrEdge>     _edgeRoute;
    TrGraph*                _trGraphPtr;
    
    std::vector<CGPoint>    _edgeRoutePath;
    std::vector<double>     _edgeRouteDistance;
    
    bool                    _hasCancelState;
};
