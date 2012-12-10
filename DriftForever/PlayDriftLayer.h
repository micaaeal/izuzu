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

@protocol PlayDriftLayerDelegate <NSObject>

- (void) onRestart: (id) sender;
- (void) onReadyToDrive: (id) sender;
- (void) onPathNotReady: (id) sender;
- (void) onWin: (id) sender;
- (void) onLost: (id) sender;

@end

@interface PlayDriftLayer : CCLayer <GameFlowSignalDelegate, StateDelegate>
{
}

+(CCScene *) scene;

@property (assign) id<PlayDriftLayerDelegate> delegate;
@property (retain) StateSelectRoute*    stateSelectRoute;
@property (retain) StateDriveCar*       stateDriveCar;
@property (retain) id<StateProtocol>    currentState;

- (void) onRstartDrive: (id) sender;
- (void) onRestart: (id) sender;
- (void) onBackToMenu: (id) sender;

- (void) setReadyToDrive: (id) sender;

- (void) onErase: (id) sender;
- (void) onDraw: (id) sender;
- (void) onZoomIn: (id) sender;
- (void) onZoomOut: (id) sender;
@end
