//
//  Score.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/14/55 BE.
//
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

+ (Score*) getObject;

@property (assign) int  totalOrder;
@property (assign) int  gotOrder;
@property (assign) double   missionTime;
@property (assign) double   driveTime;
@property (assign) double   fuelNormRemained;

- (void) reset;
- (long) calculateScore;

@end
