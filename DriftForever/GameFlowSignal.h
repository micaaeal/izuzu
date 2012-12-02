//
//  GameFlowSignal.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/1/55 BE.
//
//

#import <Foundation/Foundation.h>

@protocol GameFlowSignalDelegate <NSObject>

- (void) onStartLoadingLayer: (id) sender;
- (void) onFinishLoadingLayer: (id) sender;

- (void) onStartPlayDriftLayer: (id) sender;
- (void) onFinishPlayDriftLayer: (id) sender;

@end

@interface GameFlowSignal : NSObject

+ (GameFlowSignal*) getObject;

- (void) setAppController: (id<GameFlowSignalDelegate>) appController;
- (void) setLoadingLayer: (id<GameFlowSignalDelegate>) loadingLayer;
- (void) setDriftLayer: (id<GameFlowSignalDelegate>) driftLayer;

- (void) unSetLoadingLayer;

- (void) startLoadingLayer: (id) sender;
- (void) finishedLoadingLayer: (id) sender;

- (void) startPlayDrifLayer: (id) sender;
- (void) finishPlayDriftLayer: (id) sender;

@end
