//
//  MissionSelectViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import "WorldSelectViewController.h"

@interface WorldSelectViewController ()

@end

@implementation WorldSelectViewController
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

- (IBAction)onPressSelectWorld:(id)sender
{
    if ( delegate )
    {
        [delegate onSelectWorld:self];
    }
}

- (IBAction)onPressBackButton:(id)sender
{
    if ( delegate )
    {
        [delegate onBack:self];
    }
}

@end
