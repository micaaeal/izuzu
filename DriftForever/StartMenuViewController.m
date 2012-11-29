//
//  StartMenuViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/28/55 BE.
//
//

#import "StartMenuViewController.h"

@interface StartMenuViewController ()

@end

@implementation StartMenuViewController
@synthesize delegate;

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
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPressStartButton:(id)sender
{
    [self.view addSubview:_carAndCharacterViewController.view];
    _carAndCharacterViewController.delegate = self;
}

- (void)dealloc {
    [_carAndCharacterViewController release];
    [_worldSelectViewController release];
    [_missionViewController release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCarAndCharacterViewController:nil];
    [self setWorldSelectViewController:nil];
    [self setMissionViewController:nil];
    [super viewDidUnload];
}

#pragma mark - Next and Back beheavior

- (void) onNext:(id)sender
{
    if ( sender == _carAndCharacterViewController )
    {
        // load WorldSelectView
        [self.view addSubview:_worldSelectViewController.view];
        _worldSelectViewController.delegate = self;
    }
}

- (void) onBack:(id)sender
{
    if ( sender == _worldSelectViewController )
    {
        // load CarAndCharView
        [self.view addSubview:_carAndCharacterViewController.view];
        _carAndCharacterViewController.delegate = self;
    }
    else if ( sender == _missionViewController )
    {
        // load WorldSelectView
        [self.view addSubview:_worldSelectViewController.view];
        _worldSelectViewController.delegate = self;
    }
}

#pragma mark - WorldSelectViewDelegate

- (void) onSelectWorld:(id)sender
{
    [self.view addSubview:_missionViewController.view];
    _missionViewController.delegate = self;
}

#pragma mark - MissionSelectViewDelegate

- (void) onSelectMission:(id)sender
{
    if ( delegate )
    {
        [delegate onStartPlayingGame:self];
    }
}

@end
