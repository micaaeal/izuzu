//
//  AppDelegate.m
//  DriftForever
//
//  Created by Adawat Chanchua on 9/22/55 BE.
//  Copyright __MyCompanyName__ 2555. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "LoadingViewController.h"

@interface AppController()
{
	UIWindow *window_;
	CCDirectorIOS	*director_;							// weak ref
}

@property (retain) UIViewController* _rootViewController;
@property (retain) UINavigationController *navController_;
@property (retain) GamePlayViewController* _gamePlayViewController;
@property (retain) LoadingViewController* _loadingViewController;
@property (assign) BOOL _hasLoadedPlayDriftLayer;
@property (assign) BOOL _isOnResume;
@property (retain) CCScene* _playDriftScene;
@property (retain) CCGLView* _glView;

- (void) _loadMenuView;
- (void) _unloadMenuView;

- (void) _resumeCocosDirector;

@end

@implementation AppController

@synthesize _rootViewController;
@synthesize window=window_, navController=navController_, director=director_;
@synthesize _gamePlayViewController;
@synthesize _loadingViewController;

@synthesize _hasLoadedPlayDriftLayer;
@synthesize _isOnResume;
@synthesize _playDriftScene;
@synthesize _glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // register to gameFlowSignal
    [[GameFlowSignal getObject] setAppController:self];
    _hasLoadedPlayDriftLayer    = NO;
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // create rootViewController
    _rootViewController = [[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil] autorelease];
    [window_ setRootViewController:_rootViewController];

    if ( _GAME_MODE_ == _GAME_MODE_MAINSTREAM_ )
    {
        [self _loadMenuView];
    }
    else if ( _GAME_MODE_ == _GAME_MODE_DEBUG_ )
    {
        [self _loadCocosDirector];
    }
    
	// make main window visible
	[window_ makeKeyAndVisible];
	
    return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
    [_rootViewController release];

	[super dealloc];
}

#pragma mark - StartMenuViewDelegate

- (void) onStartPlayingGame:(id)sender
{
    [self _unloadMenuView];
    
    if ( ! _hasLoadedPlayDriftLayer )
    {
        _hasLoadedPlayDriftLayer    = YES;
        [self _loadCocosDirector];
    }
    else
    {
        [self _resumeCocosDirector];
    }
}

#pragma mark - PIMPL

- (void) _loadMenuView
{
    // create rootViewController
    StartMenuViewController* smvc = [[[StartMenuViewController alloc] initWithNibName:@"StartMenuViewController" bundle:nil] retain];
    [_rootViewController.view addSubview:smvc.view];
    [_rootViewController.view bringSubviewToFront:smvc.view];
    smvc.delegate   = self;
}

- (void) _unloadMenuView
{
    
}

- (void) _loadCocosDirector
{
    _isOnResume = NO;
    
    // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	director_.wantsFullScreenLayout = YES;
    
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
    
	// attach the openglView to the director
	[director_ setView:glView];
    
	// for rotation and other messages
	[director_ setDelegate:self];
    
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    //	[director setProjection:kCCDirectorProjection3D];
    
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	/*
    CCScene* cIntroScene  = [IntroLayer scene];
    [director_ pushScene:cIntroScene];
    IntroLayer* introLayer  = (IntroLayer*)[cIntroScene getChildByTag:101];
    [introLayer loadResources];
	*/
    
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
    
    _gamePlayViewController = [[GamePlayViewController alloc]
                               initWithNibName:@"GamePlayViewController" bundle:nil];
    [_gamePlayViewController.view addSubview:navController_.view];
    navController_.view.frame   = _gamePlayViewController.view.bounds;
    
    [_rootViewController.view addSubview:_gamePlayViewController.view];
    [_rootViewController.view bringSubviewToFront:_gamePlayViewController.view];
    [_gamePlayViewController bringUIViewToFront];
    
    _gamePlayViewController.delegate    = self;
    [_gamePlayViewController initDataByHand:self];
    
    _isOnResume = NO;
    [[GameFlowSignal getObject] startLoadingLayer:self];
}

- (void) _resumeCocosDirector
{
    _isOnResume = YES;
    [[GameFlowSignal getObject] startLoadingLayer:self];
}

#pragma mark - GameFlowSignalDelegate

- (void) onStartLoadingLayer:(id)sender
{
    // create loadingViewController
    if ( ! _loadingViewController )
    {
        _loadingViewController  = [[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil] retain];
    }
    [_rootViewController.view addSubview:_loadingViewController.view];
    [_rootViewController.view bringSubviewToFront:_loadingViewController.view];
    [_loadingViewController initDataByHandWithOption:_isOnResume];
}

- (void) onFinishLoadingLayer:(id)sender
{
    [[GameFlowSignal getObject] startPlayDrifLayer:self];
}

- (void) onStartPlayDriftLayer:(id)sender
{
    if ( ! _isOnResume )
    {
        // ....
        [_rootViewController.view addSubview:_gamePlayViewController.view];
        [_rootViewController.view bringSubviewToFront:_gamePlayViewController.view];
        [_gamePlayViewController bringUIViewToFront];
        
        _playDriftScene  = [PlayDriftLayer scene];
        /*
        [director_ pushScene:[CCTransitionFade transitionWithDuration:1.0
                                                                scene:_playDriftScene
                                                            withColor:ccWHITE]];
        */
        [director_ pushScene:_playDriftScene];
        PlayDriftLayer* playDriftLayer  = (PlayDriftLayer*)[_playDriftScene getChildByTag:101];
        playDriftLayer.delegate = self;
        _gamePlayViewController.playDriftLayer  = playDriftLayer;
        
        [_gamePlayViewController initDataByHand:self];
        // ....
    }
    else
    {
        // ....
        [_rootViewController.view addSubview:_gamePlayViewController.view];
        [_rootViewController.view bringSubviewToFront:_gamePlayViewController.view];
        [_gamePlayViewController bringUIViewToFront];
        
        PlayDriftLayer* playDriftLayer  = (PlayDriftLayer*)[_playDriftScene getChildByTag:101];
        playDriftLayer.delegate = self;
        _gamePlayViewController.playDriftLayer  = playDriftLayer;
        
        [_gamePlayViewController initDataByHand:self];
        // ....
    }
}

- (void) onFinishPlayDriftLayer:(id)sender
{
    [self _loadMenuView];
}

#pragma mark - PlayDriftLayerDelegate

- (void) onWin:(id)sender
{
    [_gamePlayViewController onWin:self];
}

- (void) onLost:(id)sender
{
    [_gamePlayViewController onLost:self];
}

- (void) onReadyToDrive:(id)sender
{
    [_gamePlayViewController onReadyToDrive:self];
}

- (void) onPathNotReady: (id) sender
{
    [_gamePlayViewController onPathNotFinishYet:self];
}

- (void) onRestart:(id)sender
{
    [_gamePlayViewController onRestart:self];
}

#pragma mark - GamePlayViewDelegate

- (void) onGoDrive:(id)sender
{
    [_gamePlayViewController.playDriftLayer setReadyToDrive:self];
}

- (void) onBack: (id) sender
{
    [_gamePlayViewController.playDriftLayer onBackToMenu:self];
}

- (void) onErase: (id) sender
{
    [_gamePlayViewController.playDriftLayer onErase:self];
}

- (void) onDraw: (id) sender
{
    [_gamePlayViewController.playDriftLayer onDraw:self];
}

- (void) onZoomIn:(id)sender
{
    [_gamePlayViewController.playDriftLayer onZoomIn:self];
}

- (void) onZoomOut:(id)sender
{
    [_gamePlayViewController.playDriftLayer onZoomOut:self];
}

@end

