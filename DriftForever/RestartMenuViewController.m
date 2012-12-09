//
//  RestartMenuViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/9/55 BE.
//
//

#import "RestartMenuViewController.h"

@interface RestartMenuViewController ()

@end

@implementation RestartMenuViewController

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
    [_btnResume setImage:[UIImage imageNamed:@"restartMenu01_02.png"] forState:UIControlStateHighlighted];
    [_btnRestart setImage:[UIImage imageNamed:@"restartMenu02_02.png"] forState:UIControlStateHighlighted];
    [_btnNewPath setImage:[UIImage imageNamed:@"restartMenu03_02.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnResume release];
    [_btnRestart release];
    [_btnNewPath release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnResume:nil];
    [self setBtnRestart:nil];
    [self setBtnNewPath:nil];
    [super viewDidUnload];
}
- (IBAction)onResume:(id)sender {
    if ( _delegate )
    {
        [_delegate onResume:self];
    }
}

- (IBAction)onRestart:(id)sender {
    if ( _delegate )
    {
        [_delegate onRestart:self];
    }
}

- (IBAction)onNewPath:(id)sender {
    if ( _delegate )
    {
        [_delegate onNewPath:self];
    }
}
@end
