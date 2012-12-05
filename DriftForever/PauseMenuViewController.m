//
//  PauseMenuViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import "PauseMenuViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onResume:(id)sender {
    // UI..
    [self.view removeFromSuperview];
}

- (IBAction)onRetry:(id)sender {
}

- (IBAction)onExit:(id)sender {
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
