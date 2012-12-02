//
//  PlayDriftLayer.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameFlowSignal.h"

@interface PlayDriftLayer : CCLayer <GameFlowSignalDelegate>
{
}

+(CCScene *) scene;

@end
