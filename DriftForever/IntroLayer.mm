//
//  IntroLayer.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/22/55 BE.
//  Copyright __MyCompanyName__ 2555. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "PlayDriftLayer.h"

#import "World.h"
#import "Car.h"
#import "Console.h"
#import "ComboPlayer.h"

#pragma mark - IntroLayer

CCScene*    _s_introScene   = nil;
IntroLayer* _s_introLayer   = nil;

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene  = [CCScene node];
    _s_introScene   = scene;
    
    // 'layer' is an autorelease object.
    IntroLayer *layer = [IntroLayer node];
    layer.tag   = 101;
    
    // add layer as a child to scene
    [_s_introScene addChild: layer];
    
    _s_introLayer   = layer;
    
	// return the scene
	return _s_introScene;
}

// 
-(void) onEnter
{
	[super onEnter];

    [[GameFlowSignal getObject] setLoadingLayer:self];
    
	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);
    
    [self addChild: background];
}

- (void) loadResources
{
    // In one second transition to the new scene
    [self scheduleOnce:@selector(makeTransition:) delay:1];
    
    // Load ...
    [[World getObject] LoadData];
    [Car LoadData];
    [[Mission getObject] loadData];
    [[Console getObject] LoadData];
    [[ComboPlayer getObject] LoadData];
    
    [[GameFlowSignal getObject] finishedLoadingLayer:self];
}

-(void) makeTransition:(ccTime)dt
{
    
}

#pragma mark - GameFlowSignalDelegate

- (void) onStartLoadingLayer:(id)sender
{
    
}

- (void) onFinishLoadingLayer:(id)sender
{
    
}

- (void) onStartPlayDriftLayer:(id)sender
{
    // do nothing
}

- (void) onFinishPlayDriftLayer:(id)sender
{

}

@end
