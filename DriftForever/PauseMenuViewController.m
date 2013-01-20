//
//  PauseMenuViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import "PauseMenuViewController.h"
#import "Fade.h"

@interface PauseMenuViewController ()

@end

@implementation PauseMenuViewController

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
    
    // set button highlight state
    [_btnResume setImage:[UIImage imageNamed:@"pauseMenu01_02.png"] forState:UIControlStateHighlighted];
    [_btnRetry setImage:[UIImage imageNamed:@"pauseMenu02_02.png"] forState:UIControlStateHighlighted];
    [_btnExit setImage:[UIImage imageNamed:@"pauseMenu03_02.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onResume:(id)sender
{
    if ( _delegate )
    {
        [_delegate onResume:self];
    }
}

- (IBAction)onRetry:(id)sender
{
    if ( _delegate )
    {
        [_delegate onRetry:self];
    }
}

- (IBAction)onExit:(id)sender
{
    [[Fade getObject] blackIt];
    
    if ( _delegate )
    {
        [_delegate onExit:self];
    }
}

- (void)dealloc {
    [_btnResume release];
    [_btnRetry release];
    [_btnExit release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnResume:nil];
    [self setBtnRetry:nil];
    [self setBtnExit:nil];
    [super viewDidUnload];
}
@end
