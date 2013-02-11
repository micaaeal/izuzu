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
    double order    = 0;
    if ( _totalOrder )
    {
        order   = gotOrder / totalOrder;
    }
    else
    {
        order   = 1;
    }
    
    // time
    double remainTime   = _missionTime - _driveTime;
    if ( remainTime < 0.0 )
        remainTime  = 0.0;
    double time  = remainTime * 1.7f / _missionTime;
    
    if ( time > 1.0f )
        time    = 1.0f;
    
    // fuel
    double fuel  = _fuelNormRemained;
    
    double score    = ( order + time + fuel ) / 3.0;
    
    long maxScore   = 10000;
    long minScore   = 1000;
    long elapseScore    = maxScore - minScore;
    
    long netScore   = ( elapseScore * score ) + minScore;
    
    return netScore;
}

- (enum SCORE_LEVEL) getScoreLevelFromScore: (long) score
{
    if ( score > 7000 )
        return SCORE_LEVEL_HIGH;
    if ( score > 4000 )
        return SCORE_LEVEL_EVERAGE;
    return SCORE_LEVEL_LOW;
}

@end
