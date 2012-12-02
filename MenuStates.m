//
//  MenuStates.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/30/55 BE.
//
//

#import "MenuStates.h"

static MenuStates*    _s_missionState = nil;

@implementation MenuStates

+ (MenuStates*) getObject
{
    if ( ! _s_missionState )
    {
        _s_missionState = [[MenuStates alloc] init];
        [_s_missionState resetAllStates];
    }
    return _s_missionState;
}

- (void) resetAllStates
{
    _playerName     = @"";
    _genderCode     = 0;
    _carCode        = 0;
    _worldCode      = 0;
    _missionCode    = 0;
}

- (void) printMenuStates
{
    printf ("Menu State:");
    printf ("\n");
    printf ("playeName: %s", [_playerName UTF8String]);
    printf ("\n");
    printf ("genderCode: %d", _genderCode);
    printf ("\n");
    printf ("carCode: %d", _carCode);
    printf ("\n");
    printf ("worldCode: %d", _worldCode);
    printf ("\n");
    printf ("missionCode: %d", _missionCode);
    printf ("\n");
}

@end
