//
//  GamePlayViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import "GamePlayViewController.h"

@interface GamePlayViewController ()

@end

@implementation GamePlayViewController

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

- (void)dealloc {
    [_pauseMenuViewController release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPauseMenuViewController:nil];
    [super viewDidUnload];
}
- (IBAction)onPause:(id)sender {
    [self.view addSubview:_pauseMenuViewController.view];
    [self.view bringSubviewToFront:_pauseMenuViewController.view];
}
@end
