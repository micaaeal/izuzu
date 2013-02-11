//
//  Score.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/14/55 BE.
//
//

#import <Foundation/Foundation.h>

enum SCORE_LEVEL {
    SCORE_LEVEL_HIGH = 0,
    SCORE_LEVEL_EVERAGE,
    SCORE_LEVEL_LOW,
    };

@interface Score : NSObject

+ (Score*) getObject;

@property (assign) int  totalOrder;
@property (assign) int  gotOrder;
@property (assign) double   missionTime;
@property (assign) double   driveTime;
@property (assign) double   fuelNormRemained;

- (void) reset;
- (long) calculateScore;
- (enum SCORE_LEVEL) getScoreLevelFromScore: (long) score;

@end
