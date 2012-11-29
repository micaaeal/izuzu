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

- (MenuStates*) getObject
{
    if ( ! _s_missionState )
    {
        _s_missionState = [[MenuStates alloc] init];
    }
    return _s_missionState;
}

@end
