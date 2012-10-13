//
//  Event.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/12/55 BE.
//
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (assign) float       atDistance; // value is between 0.0 - 1.0
@property (retain) NSArray*    comboArray;

- (void) reset;
- (BOOL) isComboFinished;
- (void) run: (CGFloat) dt;
- (float) getComboListProgress;
- (BOOL) testComboAtCurrentTime: (NSString*) comboKey;

@end
