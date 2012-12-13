//
//  Score.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/14/55 BE.
//
//

#import "Score.h"

Score* _s_score   = nil;

@implementation Score

+ (Score*) getObject
{
    if ( ! _s_score )
    {
        _s_score    = [[Score alloc] init];
    }
    return _s_score;
}

- (id) init
{
    self    = [super init];
    if ( self )
    {
        [self reset];
    }
    return self;
}

- (void) reset
{
    _totalOrder = 0;
    _gotOrder   = 0;
    _missionTime = 0.0;
    _driveTime  = 0.0;
    _fuelNormRemained   = 0.0;
}

- (long) calculateScore
{
    // order
    double gotOrder     = (double)_gotOrder;
    double totalOrder   = (double)_totalOrder;
    double order = gotOrder / totalOrder;
    
    // time
    double remainTime   = _missionTime - _driveTime;
    if ( remainTime < 0.0 )
        remainTime  = 0.0;
    double time  = remainTime / _missionTime;
    
    // fuel
    double fuel  = _fuelNormRemained;
    
    double score    = ( order + time + fuel ) / 3.0;
    
    long maxScore   = 10000;
    long minScore   = 1000;
    long elapseScore    = maxScore - minScore;
    
    long netScore   = ( elapseScore * score ) + minScore;
    
    return netScore;
}

@end
