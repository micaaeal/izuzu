//
//  MissionSelectViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import "MissionSelectViewController.h"
#import "Mission.h"

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
    
    [_btnBack setImage:[UIImage imageNamed:@"backButton02"] forState:UIControlStateHighlighted];
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
    [_btnBack release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setBtnMission01:nil];
    [self setBtnMission02:nil];
    [self setBtnMission03:nil];
    [self setBtnMission04:nil];
    [self setBtnMission05:nil];
    [self setBtnBack:nil];
    [super viewDidUnload];
}

- (IBAction)onSelectMission:(id)sender
{
    // set button by clicking at button
    int cMissionCode   = 0;
    if ( sender == _btnMission01 )
    {
        cMissionCode   = 0;
    }
    else if ( sender == _btnMission02 )
    {
        cMissionCode   = 1;
    }
    else if ( sender == _btnMission03 )
    {
        cMissionCode   = 2;
    }
    else if ( sender == _btnMission04 )
    {
        cMissionCode   = 3;
    }
    else if ( sender == _btnMission05 )
    {
        cMissionCode   = 4;
    }
    [[Mission getObject] setCurrentMissionCode:cMissionCode];
    
    // delegate callback
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
