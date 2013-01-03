//
//  CarAndCharViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/28/55 BE.
//
//

#import "CarAndCharViewController.h"
#import "MenuStates.h"

@interface CarAndCharViewController ()

@property (retain) NSArray* _carImageNameArray;
@property (retain) NSArray* _characterImageNameArray;

@property (assign) int  _currentCarIndex;

@end

@implementation CarAndCharViewController
@synthesize delegate;

@synthesize _carImageNameArray;
@synthesize _characterImageNameArray;
@synthesize _currentCarIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    
    return self;
}

- (void)dealloc {
    [_txtPlayerName release];
    [_btnMale release];
    [_btnFemale release];
    [_btnCarPrev release];
    [_btnCarNext release];
    [_imgCar release];
    [_imgCharacter release];
    [_btnOK release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set cars
    if ( ! _carImageNameArray )
    {
        _carImageNameArray  = [[NSArray alloc] initWithObjects:
                               @"car_01_01_Run001.png",
                               @"car_01_02_Run001.png",
                               @"car_01_03_Run001.png",
                               @"car_02_01_Run001.png",
                               @"car_02_02_Run001.png",
                               @"car_02_03_Run001.png",
                               nil];
    }
    
    // set gender
    if ( ! _characterImageNameArray )
    {
        _characterImageNameArray    = [[NSArray alloc] initWithObjects:
                                       @"man01.png",
                                       @"woman01.png",nil];
    }

    // button
    NSString* maleImageName     = @"maleButton02.png";
    NSString* femaleImageName   = @"femaleButton01.png";
    [_btnMale setImage:[UIImage imageNamed:maleImageName] forState:UIControlStateNormal];
    [_btnFemale setImage:[UIImage imageNamed:femaleImageName] forState:UIControlStateNormal];
    
    [_btnCarNext setImage:[UIImage imageNamed:@"rightArrow02.png"] forState:UIControlStateHighlighted];
    [_btnCarPrev setImage:[UIImage imageNamed:@"leftArrow02.png"] forState:UIControlStateHighlighted];
    
    [_btnOK setImage:[UIImage imageNamed:@"okButton02"] forState:UIControlStateHighlighted];
    
    // set gender image from data
    int genderCode              = [[MenuStates getObject] genderCode];
    NSString* charImageName     = [_characterImageNameArray objectAtIndex:genderCode];
    UIImage* charImage          = [UIImage imageNamed:charImageName];
    [_imgCharacter setImage:charImage];
    
    // set car index
    _currentCarIndex        = [[MenuStates getObject] carCode];
    NSString* carImageName  = [_carImageNameArray objectAtIndex:_currentCarIndex];
    UIImage* carImage       = [UIImage imageNamed:carImageName];
    [_imgCar setImage:carImage];
    
    // UI.
    _txtPlayerName.delegate = self;
}

- (void)viewDidUnload {
    
    if ( _carImageNameArray )
    {
        [_carImageNameArray release];
        _carImageNameArray  = nil;
    }
    if ( _characterImageNameArray )
    {
        [_characterImageNameArray release];
        _characterImageNameArray    = nil;
    }
    
    [self setTxtPlayerName:nil];
    [self setBtnMale:nil];
    [self setBtnFemale:nil];
    [self setBtnCarPrev:nil];
    [self setBtnCarNext:nil];
    [self setImgCar:nil];
    [self setImgCharacter:nil];
    [self setBtnOK:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. 
}

- (IBAction)onPressMale:(id)sender {
    
    // button
    NSString* maleImageName     = @"maleButton02.png";
    NSString* femaleImageName   = @"femaleButton01.png";
    [_btnMale setImage:[UIImage imageNamed:maleImageName] forState:UIControlStateNormal];
    [_btnFemale setImage:[UIImage imageNamed:femaleImageName] forState:UIControlStateNormal];
    
    // image
    NSString* charImageName   = [_characterImageNameArray objectAtIndex:0];
    UIImage* charImage          = [UIImage imageNamed:charImageName];
    [_imgCharacter setImage:charImage];
    
    // data
    [[MenuStates getObject] setGenderCode:0];
    
    // UI.
    if ( _txtPlayerName.isFirstResponder )
    {
        [_txtPlayerName resignFirstResponder];
    }
}

- (IBAction)onPressFemale:(id)sender {
    
    // button
    NSString* maleImageName     = @"maleButton01.png";
    NSString* femaleImageName   = @"femaleButton02.png";
    [_btnMale setImage:[UIImage imageNamed:maleImageName] forState:UIControlStateNormal];
    [_btnFemale setImage:[UIImage imageNamed:femaleImageName] forState:UIControlStateNormal];
    
    // image
    NSString* charImageName     = [_characterImageNameArray objectAtIndex:1];
    UIImage* charImage          = [UIImage imageNamed:charImageName];
    [_imgCharacter setImage:charImage];
    
    // data
    [[MenuStates getObject] setGenderCode:1];
    
    // UI.
    if ( _txtPlayerName.isFirstResponder )
    {
        [_txtPlayerName resignFirstResponder];
    }
}

- (IBAction)onPressCarNext:(id)sender {

    int carCount    = _carImageNameArray.count;
    [MenuStates getObject].carCount = carCount;
 
    ++_currentCarIndex;
    
    if ( _currentCarIndex >= carCount )
    {
        _currentCarIndex    = 0;
    }
    
    NSString* carImageName  = [_carImageNameArray objectAtIndex:_currentCarIndex];
    UIImage* carImage       = [UIImage imageNamed:carImageName];
    [_imgCar setImage:carImage];
    
    // Data
    [[MenuStates getObject] setCarCode:_currentCarIndex];
    
    // UI.
    if ( _txtPlayerName.isFirstResponder )
    {
        [_txtPlayerName resignFirstResponder];
    }
    
}

- (IBAction)onPressCarPrev:(id)sender {
    
    int carCount    = _carImageNameArray.count;
    [MenuStates getObject].carCount = carCount;
    
    --_currentCarIndex;
    
    if ( _currentCarIndex < 0 )
    {
        _currentCarIndex    = carCount - 1;
    }
    
    NSString* carImageName  = [_carImageNameArray objectAtIndex:_currentCarIndex];
    UIImage* carImage       = [UIImage imageNamed:carImageName];
    [_imgCar setImage:carImage];
    
    // Data
    [[MenuStates getObject] setCarCode:_currentCarIndex];
    
    // UI.
    if ( _txtPlayerName.isFirstResponder )
    {
        [_txtPlayerName resignFirstResponder];
    }
    
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
    
    // Data
    [[MenuStates getObject] setPlayerName:_txtPlayerName.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    // Data
    [[MenuStates getObject] setPlayerName:textField.text];
    
    return YES;
}

@end
