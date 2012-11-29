//
//  MissionSelectViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import "MissionSelectViewController.h"

@interface MissionSelectViewController ()

@end

@implementation MissionSelectViewController
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnMission01 release];
    [_btnMission02 release];
    [_btnMission03 release];
    [_btnMission04 release];
    [_btnMission05 release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setBtnMission01:nil];
    [self setBtnMission02:nil];
    [self setBtnMission03:nil];
    [self setBtnMission04:nil];
    [self setBtnMission05:nil];
    [super viewDidUnload];
}

- (IBAction)onSelectMission:(id)sender
{
    if ( delegate )
    {
        [delegate onSelectMission:self];
    }
}

- (IBAction)onBack:(id)sender
{
    if ( delegate )
    {
        [delegate onBack:self];
    }
}

@end
