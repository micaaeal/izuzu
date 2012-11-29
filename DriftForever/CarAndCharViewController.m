//
//  CarAndCharViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/28/55 BE.
//
//

#import "CarAndCharViewController.h"

@interface CarAndCharViewController ()

@end

@implementation CarAndCharViewController
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

- (IBAction)onPressOKButton:(id)sender
{
    if ( delegate )
    {
        [delegate onNext:self];
    }
}

- (IBAction)onTouchRootView:(id)sender
{
    if ( _txtPlayerName.isFirstResponder )
    {
        [_txtPlayerName resignFirstResponder];
    }
}

- (void)dealloc {
    [_txtPlayerName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtPlayerName:nil];
    [super viewDidUnload];
}
@end
