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

@interface PlayDriftLayer()

@property (retain) id<StateProtocol>    _currentState;
@property (retain) StateSelectRoute*    _stateSelectRoute;
@property (retain) StateDriveCar*       _stateDriveCar;

@property (assign) BOOL     _isDebug;

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
        
        // init camera
        [Camera initCameraWithLayer:self];
        
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
    }
	return self;
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
    BOOL isNotFinishedYet  = [_currentState onUpdate:dt];
    if ( isNotFinishedYet )
        return;
    
    // start new state
    if ( _currentState == _stateSelectRoute )
    {
        _currentState   = _stateDriveCar;
    }
    else
    {
        CCLOG(@"State Not Found!!!!");
    }
    
    [_currentState setLayer:self];
    [_currentState onStart];
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

CGPoint _lastTouchBeganLocation;
CGPoint _lastTouchMovedLocation;

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_currentState onTouchBegan:touch withEvent:event];

    if ( _isDebug )
    {
        // to move the screen
        CGPoint location = [self convertTouchToNodeSpace: touch];
        _lastTouchBeganLocation = location;
        _lastTouchMovedLocation = location;
        //return YES;
        
        // to get touch position
        {
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            CGFloat touchX      = location.x;
            CGFloat touchY      = location.y;
            
            float centerX, centerY, centerZ;
            float eyeX, eyeY, eyeZ;
            [self.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
            [self.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
            
            CGFloat touchCameraX    = touchX + centerX;
            CGFloat touchCameraY    = touchY + centerY;
            printf ("touching at: (%f, %f)", touchCameraX, touchCameraY);
            printf ("\n");
        }
    }

    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_currentState onTouchMoved:touch withEvent:event];

    if ( _isDebug )
    {
        CGPoint location = [self convertTouchToNodeSpace: touch];
        CGPoint movedLocation   = CGPointMake(location.x-_lastTouchMovedLocation.x,
                                              location.y-_lastTouchMovedLocation.y);
        _lastTouchMovedLocation = location;
        
        // move camera
        float centerX, centerY, centerZ;
        float eyeX, eyeY, eyeZ;
        [self.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
        [self.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
        float moveX = movedLocation.x;
        float moveY = movedLocation.y;
        float moveZ = 0.0f;
        float newX  = centerX - moveX;
        float newY  = centerY - moveY;
        float newZ  = centerZ - moveZ;
        float newEyeX  = eyeX - moveX;
        float newEyeY  = eyeY - moveY;
        float newEyeZ  = eyeZ - moveZ;
        [self.camera setCenterX:newX centerY:newY centerZ:newZ];
        [self.camera setEyeX:newEyeX eyeY:newEyeY eyeZ:newEyeZ];
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
