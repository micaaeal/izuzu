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

@interface LoadingViewController ()

@property (assign) float loadingTimeMin;

- (void) _onFinishLoadingLayer;

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
    
    _loadingTimeMin = 1.5f;
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
    NSDate* date01   = [NSDate date];
    if ( ! isResume )
    {
        // Load resources
        [[World getObject] LoadData];
        [Car LoadData];
        [[Mission getObject] loadData];
        [[Console getObject] LoadData];
        [[ComboPlayer getObject] LoadData];
    }
    NSDate* date02  = [NSDate date];
    
    NSTimeInterval deltaTime    = date02.timeIntervalSince1970 - date01.timeIntervalSince1970;

    NSTimeInterval timeDelayAdd = _loadingTimeMin - deltaTime;
    
    if ( timeDelayAdd < 0.0f )
        timeDelayAdd    = 0.0f;
    
    [NSTimer scheduledTimerWithTimeInterval:_loadingTimeMin
                                     target:self
                                   selector:@selector(_onFinishLoadingLayer)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - PIMPL

- (void) _onFinishLoadingLayer
{
    [[GameFlowSignal getObject] finishedLoadingLayer:self];
}

@end
