//
//  MenuStates.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/30/55 BE.
//
//

#import <Foundation/Foundation.h>

enum GENDER_CODE {
    GENDER_MALE = 0,
    GENDER_FEMALE,
    
    GENDER_COUNT,
    };

@interface MenuStates : NSObject

+ (MenuStates*) getObject;

@property (copy)    NSString*   playerName;
@property (assign)  int         genderCode;
@property (assign)  int         carCode;
@property (assign)  int         worldCode;
@property (assign)  int         missionCode;

- (void) resetAllStates;
- (void) printMenuStates;

@end
