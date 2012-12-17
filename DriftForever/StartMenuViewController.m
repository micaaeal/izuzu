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
    NSMutableString* nibName    = [[NSMutableString alloc] initWithString:nibNameOrNil];
    if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [nibName appendString:@"_iPad"];
        }
    }
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _carAndCharacterViewController  = [[CarAndCharViewController alloc] initWithNibName:@"CarAndCharViewController" bundle:nil];
        _worldSelectViewController      = [[WorldSelectViewController alloc] initWithNibName:@"WorldSelectViewController" bundle:nil];
        _missionViewController          = [[MissionSelectViewController alloc] initWithNibName:@"MissionSelectViewController" bundle:nil];
    }
    
    [nibName release];
    nibName = nil;
    
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
    [self.view bringSubviewToFront:_carAndCharacterViewController.view];
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
        [self.view bringSubviewToFront:_worldSelectViewController.view];
    }
}

- (void) onBack:(id)sender
{
    if ( sender == _worldSelectViewController )
    {
        // load CarAndCharView
        [self.view addSubview:_carAndCharacterViewController.view];
        _carAndCharacterViewController.delegate = self;
        [self.view bringSubviewToFront:_carAndCharacterViewController.view];
    }
    else if ( sender == _missionViewController )
    {
        // load WorldSelectView
        [self.view addSubview:_worldSelectViewController.view];
        _worldSelectViewController.delegate = self;
        [self.view bringSubviewToFront:_worldSelectViewController.view];
    }
}

#pragma mark - WorldSelectViewDelegate

- (void) onSelectWorld:(id)sender
{
    [self.view addSubview:_missionViewController.view];
    _missionViewController.delegate = self;
    [self.view bringSubviewToFront:_missionViewController.view];
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
