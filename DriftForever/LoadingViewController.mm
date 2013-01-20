//
//  LoadingViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/24/55 BE.
//
//

#import "LoadingViewController.h"
#import "World.h"
#import "Car.h"
#import "Mission.h"
#import "Console.h"
#import "ComboPlayer.h"
#import "GameFlowSignal.h"
#import "Fade.h"

@interface LoadingViewController ()

@property (assign) float loadingTimeGap;

- (void) _onLoadTextureInDelay;
- (void) _onFinishLoadingLayer;


- (void) _onLoadTextureSequence_01;
- (void) _onLoadTextureSequence_02;
- (void) _onLoadTextureSequence_03;
- (void) _onLoadTextureSequence_04;
- (void) _onLoadTextureSequence_05;
- (void) _onLoadTextureSequence_06;

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _loadingTimeGap = 0.01f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) initDataByHandWithOption: (BOOL) isResume
{
    if ( ! isResume )
    {
        [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                         target:self
                                       selector:@selector(_onLoadTextureInDelay)
                                       userInfo:nil
                                        repeats:NO];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(_onFinishLoadingLayer)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark - PIMPL

- (void) _onLoadTextureInDelay
{
    /* // load all textures in 1 frame
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
    [[World getObject] LoadRoads];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    [[World getObject] LoadBuilings];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
    [[Car getObject] LoadData];
    [[Mission getObject] loadData];
    [[Console getObject] LoadData];
    [[ComboPlayer getObject] LoadData];
    
    // notify UI
    [self _onFinishLoadingLayer];
    /*/ // load textures separate frames
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_01)
                                   userInfo:nil
                                    repeats:NO];
    /**/
}

- (void) _onLoadTextureSequence_01
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
    [[World getObject] LoadRoads];

    [[Fade getObject] loadData];
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_02)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) _onLoadTextureSequence_02
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    [[World getObject] LoadBuilings];
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_03)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) _onLoadTextureSequence_03
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
    [[Car getObject] LoadData];
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_04)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) _onLoadTextureSequence_04
{
    [[Mission getObject] loadData];
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_05)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) _onLoadTextureSequence_05
{
    [[Console getObject] LoadData];
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeGap
                                     target:self
                                   selector:@selector(_onLoadTextureSequence_06)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) _onLoadTextureSequence_06
{
    [[ComboPlayer getObject] LoadData];
    
    [self _onFinishLoadingLayer];
}

- (void) _onFinishLoadingLayer
{
    [[GameFlowSignal getObject] finishedLoadingLayer:self];
}

@end
