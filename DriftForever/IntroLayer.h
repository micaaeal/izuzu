//
//  IntroLayer.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/22/55 BE.
//  Copyright __MyCompanyName__ 2555. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameFlowSignal.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer <GameFlowSignalDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

- (void) loadResources;

@end
