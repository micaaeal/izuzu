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

// graph
#import "RouteGraph.h"
#import <vector>
using namespace std;

// states
#import "StateSelectRoute.h"
#import "StateDriveCar.h"

// camera
#import "Camera.h"

static CCMenu*          _s_debugMenu    = NULL;
static CCMenuItemFont*  _s_restartBtn   = NULL;

@interface PlayDriftLayer()

@property (retain) id<StateProtocol>    _currentState;
@property (retain) StateSelectRoute*    _stateSelectRoute;
@property (retain) StateDriveCar*       _stateDriveCar;

@property (assign) BOOL     _isDebug;

- (void) _onRestart: (id) sender;
- (void) _onZoomIn: (id) sender;
- (void) _onZoomOut: (id) sender;
- (void) _onCancel: (id) sender;

@end

@implementation PlayDriftLayer
@synthesize _stateSelectRoute;
@synthesize _stateDriveCar;
@synthesize _currentState;
@synthesize _isDebug;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayDriftLayer *layer = [PlayDriftLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        // set flags
        _isDebug    = YES;
        
        // init states
        _stateSelectRoute   = [[StateSelectRoute alloc] init];
        _stateDriveCar      = [[StateDriveCar alloc] init];
        _currentState       = _stateSelectRoute;
        
        // assign data from world
        [World AssignDataToLayer:self withMission:nil];
        
        // assign data from car
        [Car AssignDataToLayer:self withMission:nil];
        
        // set touch enable
        self.isTouchEnabled = YES;
        
        // create update schedule
        [self schedule:@selector(onUpdate:)];
        
        // start state
        [_currentState setLayer:self];
        [_currentState onStart];
        
        // add restart button
        UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];

        // restart button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"button_blue_restart"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(mWindow.bounds.size.width-img.size.width,
                                      mWindow.bounds.size.height-img.size.height,
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onRestart:)
          forControlEvents:UIControlEventTouchDown];
        }
        // zoom-in button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"plus"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(mWindow.bounds.size.width-img.size.width,
                                      mWindow.bounds.size.height-img.size.height-80.0f,
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onZoomIn:)
          forControlEvents:UIControlEventTouchDown];
        }
        // zoom-out button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"minus"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(mWindow.bounds.size.width-img.size.width,
                                      mWindow.bounds.size.height-img.size.height-160.0f,
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onZoomOut:)
          forControlEvents:UIControlEventTouchDown];
        }
        /* // cancel button
        {
            UIButton* btn    = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage* img   = [UIImage imageNamed:@"cancel"];
            [btn setImage:img forState:UIControlStateNormal];
            btn.frame    = CGRectMake(mWindow.bounds.size.width-img.size.width,
                                      mWindow.bounds.size.height-img.size.height-240.0f,
                                      img.size.width,
                                      img.size.height);
            [mWindow addSubview:btn];
            [mWindow bringSubviewToFront:btn];
            [btn addTarget:self
                    action:@selector(_onCancel:)
          forControlEvents:UIControlEventTouchDown];
        }
        */
        
        // camera
        [[Camera getObject] initCameraWithLayer:self];
    }
	return self;
}

- (void) _onRestart: (id) sender
{
    [_currentState onFinish];
    
    _currentState   = _stateSelectRoute;
    [_currentState onStart];
}

static int _s_currentZoomLevel    = 2;
static float _s_zoomLevel[]         = {0.5f, 0.75f, 1.0f, 1.5f, 2.0f};
static int   _s_zoomLevelSize       = 5;

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

- (void) _onCancel: (id) sender
{
    [_currentState onGetStringMessage:@"cancel"];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
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
    }
    else
    {
        CCLOG(@"State Not Found!!!!");
    }
}

- (void) draw
{
    [_currentState onRender];
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

@end
