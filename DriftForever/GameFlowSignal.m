//
//  GameFlowSignal.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/1/55 BE.
//
//

#import "GameFlowSignal.h"

GameFlowSignal* _s_gameFlowSignalobject   = nil;

@interface GameFlowSignal()

@property (assign) id<GameFlowSignalDelegate>   _appController;
@property (assign) id<GameFlowSignalDelegate>   _loadingLayer;
@property (assign) id<GameFlowSignalDelegate>   _driftLayer;

@end

@implementation GameFlowSignal
@synthesize _appController;
@synthesize _loadingLayer;
@synthesize _driftLayer;

+ (GameFlowSignal*) getObject
{
    if ( ! _s_gameFlowSignalobject )
    {
        _s_gameFlowSignalobject = [[GameFlowSignal alloc] init];
    }
    
    return _s_gameFlowSignalobject;
}

- (id) init
{
    self    = [super init];
    if ( self )
    {
        _appController  = nil;
        _loadingLayer   = nil;
        _driftLayer = nil;
    }
    
    return self;
}

- (void) setAppController: (id<GameFlowSignalDelegate>) appController
{
    _appController   = appController;
}

- (void) setLoadingLayer: (id<GameFlowSignalDelegate>) loadingLayer
{
    _loadingLayer   = loadingLayer;
}

- (void) setDriftLayer: (id<GameFlowSignalDelegate>) driftLayer;
{
    _driftLayer   = driftLayer;
}

- (void) unSetLoadingLayer
{
    _loadingLayer   = nil;
}

- (void) startLoadingLayer:(id)sender
{
    if ( _driftLayer )
        [_driftLayer onStartLoadingLayer:self];
    if ( _loadingLayer )
        [_loadingLayer onStartLoadingLayer:self];
    if ( _appController )
        [_appController onStartLoadingLayer:self];
}

- (void) finishedLoadingLayer:(id)sender
{
    if ( _driftLayer )
        [_driftLayer onFinishLoadingLayer:self];
    if ( _loadingLayer )
        [_loadingLayer onFinishLoadingLayer:self];
    if ( _appController )
        [_appController onFinishLoadingLayer:self];
}

- (void) startPlayDrifLayer: (id) sender
{
    if ( _driftLayer )
        [_driftLayer onStartPlayDriftLayer:self];
    if ( _loadingLayer )
        [_loadingLayer onStartPlayDriftLayer:self];
    if ( _appController )
        [_appController onStartPlayDriftLayer:self];
}

- (void) finishPlayDriftLayer: (id) sender
{
    if ( _driftLayer )
        [_driftLayer onFinishPlayDriftLayer:self];
    if ( _loadingLayer )
        [_loadingLayer onFinishPlayDriftLayer:self];
    if ( _appController )
        [_appController onFinishPlayDriftLayer:self];
}

@end
