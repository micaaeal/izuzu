//
//  MissionSelectViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import "WorldSelectViewController.h"
#import "MenuStates.h"

@interface WorldSelectViewController ()

@property (retain) NSArray* _worldButtonImageNameArray;
@property (retain) NSArray* _worldImageNameArray;
@property (assign) int      _currentWorldIndex;

- (void) _setWorldImage;

@end

@implementation WorldSelectViewController
@synthesize delegate;

@synthesize _worldButtonImageNameArray;
@synthesize _worldImageNameArray;
@synthesize _currentWorldIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)dealloc {
    [_imgWorld release];
    [_btnNextWorld release];
    [_btnPrevWorld release];
    [_btnSelectWorld release];
    [_btnBack release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // world resources
    if ( ! _worldImageNameArray )
    {
        _worldImageNameArray  = [[NSArray alloc] initWithObjects:
                                       @"world01.png",
                                       @"world02.png",
                                       @"world03.png",
                                       @"world04.png",
                                       nil];
    }
    
    if ( ! _worldButtonImageNameArray )
    {
        _worldButtonImageNameArray  = [[NSArray alloc] initWithObjects:
                                       @"world01Name.png",
                                       @"world02Name.png.png",
                                       @"world03Name.png.png",
                                       @"world04Name.png.png",
                                       nil];
    }
    
    // init world index
    _currentWorldIndex  = [[MenuStates getObject] worldCode];
    [self _setWorldImage];
    
    // UI.
    [_btnNextWorld setImage:[UIImage imageNamed:@"rightArrow02.png"] forState:UIControlStateHighlighted];
    [_btnPrevWorld setImage:[UIImage imageNamed:@"leftArrow02.png"] forState:UIControlStateHighlighted];

    [_btnBack setImage:[UIImage imageNamed:@"backButton02"] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload {
    
    if ( _worldButtonImageNameArray )
    {
        [_worldButtonImageNameArray release];
        _worldButtonImageNameArray  = nil;
    }
    if ( _worldImageNameArray )
    {
        [_worldImageNameArray release];
        _worldImageNameArray    = nil;
    }
    
    [self setImgWorld:nil];
    [self setBtnNextWorld:nil];
    [self setBtnPrevWorld:nil];
    [self setBtnSelectWorld:nil];
    [self setBtnBack:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPressNextWorld:(id)sender {
    
    int worldCount  = _worldButtonImageNameArray.count;
    
    ++_currentWorldIndex;
    
    if ( _currentWorldIndex >= worldCount )
        _currentWorldIndex  = 0;
    
    [self _setWorldImage];
}

- (IBAction)onPressPrevWorld:(id)sender {
    
    int worldCount  = _worldButtonImageNameArray.count;
    
    --_currentWorldIndex;
    
    if ( _currentWorldIndex < 0 )
        _currentWorldIndex  = worldCount - 1;
    
    [self _setWorldImage];
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

#pragma mark - PIMPL

- (void) _setWorldImage
{
    NSString* worldImageName    = [_worldImageNameArray objectAtIndex:_currentWorldIndex];
    UIImage* worldImage         = [UIImage imageNamed:worldImageName];
    [_imgWorld setImage:worldImage];
    
    NSString* worldButtonImageName    = [_worldButtonImageNameArray objectAtIndex:_currentWorldIndex];
    UIImage* worldButtonImage         = [UIImage imageNamed:worldButtonImageName];
    [_btnSelectWorld setImage:worldButtonImage forState:UIControlStateNormal];
    
    // manual set
    [_btnSelectWorld setEnabled:( _currentWorldIndex == 0 )];
}

@end
