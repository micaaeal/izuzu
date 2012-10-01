//
//  HelloWorldLayer.h
//  Drift Forever
//
//  Created by Adawat Chanchua on 10/2/55 BE.
//  Copyright __MyCompanyName__ 2555. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
