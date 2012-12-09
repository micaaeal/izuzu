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

// states
#import "StateProtocol.h"
#import "StateSelectRoute.h"
#import "StateDriveCar.h"

@interface PlayDriftLayer : CCLayer <GameFlowSignalDelegate>
{
}

+(CCScene *) scene;

@property (retain) StateSelectRoute*    stateSelectRoute;
@property (retain) StateDriveCar*       stateDriveCar;
@property (retain) id<StateProtocol>    currentState;

- (void) onRstartDrive: (id) sender;
- (void) onRestart: (id) sender;
- (void) onBackToMenu: (id) sender;

@end
