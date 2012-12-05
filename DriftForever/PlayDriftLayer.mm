//
//  PlayDriftLayer.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/26/55 BE.
//  Copyright 2555 __MyCompanyName__. All rights reserved.
//

#import "PlayDriftLayer.h"

// object modules
#import "World.h"
#import "Car.h"
#import "WindShield.h"

// graph
#import "RouteGraph.h"
#import <vector>
using namespace std;

// states
#import "StateSelectRoute.h"
#import "StateDriveCar.h"

#import "Mission.h"
#import "EventHandler.h"
#import "Console.h"
#import "ComboPlayer.h"

// camera
#import "Camera.h"

static CCMenu*          _s_debugMenu    = NULL;
static CCMenuItemFont*  _s_restartBtn   = NULL;

@interface PlayDriftLayer()

@property (retain) id<StateProtocol>    _currentState;
@property (retain) StateSelectRoute*    _stateSelectRoute;
@property (retain) StateDriveCar*       _stateDriveCar;
@property (retain) CCLayer*             _actionLayer;

@property (retain) NSMutableArray*      _debugButtons;
@property (retain) UIView*              _rootDebugButton;

@property (assign) BOOL     _isDebug;

- (void) _onToggleDebugMode: (id) sender;
- (void) _onRestart: (id) sender;
- (void) _onZoomIn: (id) sender;
- (void) _onZoomOut: (id) sender;
- (void) _onRemoveBackRoute: (id) sender;
- (void) _onBackToMenu: (id) sender;

@end

@implementation PlayDriftLayer
@synthesize _stateSelectRoute;
@synthesize _stateDriveCar;
@synthesize _currentState;
@synthesize _isDebug;
@synthesize _actionLayer;

@synthesize _debugButtons;
@synthesize _rootDebugButton;

CCScene*        _s_playDriftScene   = nil;
PlayDriftLayer* _s_playDriftLayer   = nil;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    _s_playDriftScene   = scene;
    
    // 'layer' is an autorelease object.
    PlayDriftLayer *layer = [PlayDriftLayer node];
    
    // add layer as a child to scene
    [_s_playDriftScene addChild: layer];
    
    _s_playDriftLayer   = layer;

	// return the scene
	return _s_playDriftScene;
}

// on "init" you need to initialize your instance
-(id) init
{
    // Register to GameFlowSignal
    [[GameFlowSignal getObject] setDriftLayer:self];
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        // set flags
        _isDebug    = NO;
     
        // init all sub layers
        CCLayer* actionLayer = [[[CCLayer alloc] init] autorelease];
        [self addChild:actionLayer];
        _actionLayer    = actionLayer;
        
        // init states
        _stateSelectRoute   = [[StateSelectRoute alloc] init];
        _stateDriveCar      = [[StateDriveCar alloc] init];
        [EventHandler getObject].delegate   = _stateDriveCar;
        _currentState       = _stateSelectRoute;
        
        // assign data from world
        [[World getObject] AssignDataToLayer:actionLayer withMission:nil];
        
        // assign data from event handler
        [[EventHandler getObject] onStart];
        [[EventHandler getObject] assignDataToActionLayer:actionLayer uiLayer:self];
        
        // set mission
        
        [[Mission getObject] AssignDataToLayer:actionLayer];
        
        // assign data from car
        [Car AssignDataToLayer:actionLayer withMission:nil];
        
        // assign data from Fuel
        [[Console getObject] AssignDataToLayer:self];
        [[Console getObject] hideConsole];
        
        // assign data from ComboPlayer
        [[ComboPlayer getObject] AssignDataToLayer:self];
        [ComboPlayer getObject].delegate    = _stateDriveCar;
        
        // assign data from WindShield
        [[WindShield getObject] onStart];
        [[WindShield getObject] assignDataToLayer:self];
        
        // set touch enable
        self.isTouchEnabled = YES;
        
        // create update schedule
        [self schedule:@selector(onUpdate:)];

        // start state
        [_currentState setLayer:actionLayer];
        [_currentState onStart];
        
        // camera
        [[Camera getObject] initCameraWithLayer:actionLayer];
        [[Camera getObject] zoomTo:_s_zoomLevel[_s_currentZoomLevel]];
        
        // set debug buttons
        _debugButtons   = [[NSMutableArray alloc] init];
        
        UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];

        float buttonOffset  = 80.0f;
        float buttonSpace   = 40.0f;
        int debugButtonIndex    = 0;
        // debug button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"debug"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onToggleDebugMode:)
          forControlEvents:UIControlEventTouchDown];
            _rootDebugButton    = btn;
        }
        // restart button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"button_blue_restart"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onRestart:)
          forControlEvents:UIControlEventTouchDown];
            [_debugButtons addObject:btn];
        }
        // zoom-in button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"plus"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onZoomIn:)
          forControlEvents:UIControlEventTouchDown];
            [_debugButtons addObject:btn];
        }
        // zoom-out button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"minus"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onZoomOut:)
          forControlEvents:UIControlEventTouchDown];
            [_debugButtons addObject:btn];
        }
        // cancel button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"cancel"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onRemoveBackRoute:)
          forControlEvents:UIControlEventTouchDown];
            [_debugButtons addObject:btn];
        }
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"back"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(0.0f,
                                      mWindow.bounds.size.height-img.size.height - (buttonOffset+(debugButtonIndex++)*buttonSpace),
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onBackToMenu:)
          forControlEvents:UIControlEventTouchDown];
            [_debugButtons addObject:btn];
        }
    }
    
    // hide all debug buttons
    for ( UIView* cView in _debugButtons )
    {
        [cView setHidden:YES];
    }
    
	return self;
}

- (void) _onToggleDebugMode: (id) sender
{
    BOOL isHidden   = YES;
    
    UIView* sampleView  = [_debugButtons objectAtIndex:0];
    isHidden    = !sampleView.isHidden;
    
    // hide all debug buttons
    for ( UIView* cView in _debugButtons )
    {
        [cView setHidden:isHidden];
    }
}

- (void) _onRestart: (id) sender
{
    _currentState   = _stateSelectRoute;
    [_currentState onFinish];
    [_currentState onStart];
    
    [[Console getObject] hideConsole];
}

static int _s_currentZoomLevel    = 0;
static float _s_zoomLevel[]         = {0.19f, 0.23f, 0.25f, 0.45f, 0.6f, 1.0f};
//static float _s_zoomLevel[]         = {0.1f, 0.023f, 0.025f, 0.045f, 0.06f, 0.10f};
static int   _s_zoomLevelSize       = 6;

- (void) _onZoomIn: (id) sender
{
    if ( ! ( _s_currentZoomLevel < (_s_zoomLevelSize-1) ) )
        return;
    
    ++_s_currentZoomLevel;
    
    [[Camera getObject] zoomTo:_s_zoomLevel[_s_currentZoomLevel]];
}

- (void) _onZoomOut: (id) sender
{
    if ( _s_currentZoomLevel <= 0 )
        return;
    
    --_s_currentZoomLevel;
    
    [[Camera getObject] zoomTo:_s_zoomLevel[_s_currentZoomLevel]];
}

- (void) _onRemoveBackRoute: (id) sender
{
    if ( _currentState == _stateSelectRoute )
    {
        [_currentState onGetStringMessage:@"remove_back"];
    }
}

- (void) _onBackToMenu: (id) sender
{
    [[GameFlowSignal getObject] finishPlayDriftLayer:self];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_debugButtons release];
    _debugButtons   = nil;
     
    // end state
    [_currentState onFinish];
    _currentState   = nil;
    
    // release states
    [_stateSelectRoute release];
    _stateSelectRoute   = nil;
    [_stateDriveCar release];
    _stateDriveCar  = nil;
    
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark - frame-by-frame reutines

- (void) onUpdate:(ccTime)dt
{
    // update camera
    [[Camera getObject] onUpdate:dt];
    
    // update state
    BOOL isNotFinishedYet  = [_currentState onUpdate:dt];
    if ( isNotFinishedYet )
        return;
    
    // start new state
    if ( _currentState == _stateSelectRoute )
    {
        _currentState   = _stateDriveCar;
        [_stateDriveCar setLayer:self];
        [_stateDriveCar onStart];
        [[Console getObject] showConsole];
    }
    else
    {
        CCLOG(@"State Not Found!!!!");
    }
    
    // update fuel
    [[Console getObject] Update:dt];
}

- (void) draw
{
    [_currentState onRender];
    
    [[World getObject] Draw];
}

#pragma mark - ccTouch

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

CGPoint _touchAtBegin;
CGPoint _touchDeltaLastFrame;

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_currentState onTouchBegan:touch withEvent:event];

    if ( _isDebug )
    {
        // to move the screen
        _touchAtBegin           = [touch locationInView: [touch view]];
        _touchDeltaLastFrame    = CGPointMake(0.0f, 0.0f);
    }

    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_currentState onTouchMoved:touch withEvent:event];

    if ( _isDebug )
    {
        CGFloat zoomX   = [[Camera getObject] getZoomX];
        
        // cal..
        CGPoint touchPoint  = [touch locationInView: [touch view]];
        CGPoint touchDelta  = CGPointMake((touchPoint.x - _touchAtBegin.x) / zoomX ,
                                          (touchPoint.y - _touchAtBegin.y) / zoomX );
        CGPoint vecMoveCam  = CGPointMake(touchDelta.x - _touchDeltaLastFrame.x,
                                          touchDelta.y - _touchDeltaLastFrame.y);
        _touchDeltaLastFrame    = touchDelta;
        
        // move cam
        CGPoint vecMoveCamMod  = CGPointMake(vecMoveCam.x, -vecMoveCam.y);
        [[Camera getObject] moveCameraByPoint:vecMoveCamMod];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( ! _isDebug )
    {
        [_currentState onTouchEnded:touch withEvent:event];
    }
    else
    {
        
    }
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
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
    [mWindow bringSubviewToFront:_rootDebugButton];
    for ( UIView* cView in _debugButtons )
    {
        [mWindow bringSubviewToFront:cView];
        [cView setHidden:YES];
    }
    
    [self _onRestart:sender];
}

- (void) onFinishPlayDriftLayer:(id)sender
{
    // do nothing for this object
}

@end
