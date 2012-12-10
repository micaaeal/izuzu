//
//  WinMenuViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/10/55 BE.
//
//

#import "WinLostMenuViewController.h"
#import "MenuStates.h"
#import "Mission.h"

@interface WinLostMenuViewController ()

@end

@implementation WinLostMenuViewController

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

- (IBAction)onShare:(id)sender {
    if ( _delegate )
    {
        [_delegate onShare:self];
    }
}

- (IBAction)onRestart:(id)sender {
    if ( _delegate )
    {
        [_delegate onRestart:self];
    }
}

- (IBAction)onNext:(id)sender {
    if ( _delegate )
    {
        [_delegate onNext:self];
    }
}

- (void) initDataByHand: (id) sender isWin: (BOOL) isWin
{
    enum GENDER_CODE genderCode  = [MenuStates getObject].genderCode;
    
    if ( isWin )
    {
        [_imgWinLabel setImage:[UIImage imageNamed:@"headWord01.png"]];
        
        if ( genderCode == GENDER_MALE )
        {
            [_imgCharacter setImage:[UIImage imageNamed:@"man02.png"]];
            [_imgBg setImage:[UIImage imageNamed:@"resultBG01.png"]];
        }
        else
        {
            [_imgCharacter setImage:[UIImage imageNamed:@"woman02.png"]];
            [_imgBg setImage:[UIImage imageNamed:@"resultBG02.png"]];
        }
    }
    else
    {
        [_imgWinLabel setImage:[UIImage imageNamed:@"headWord02.png"]];
        
        if ( genderCode == GENDER_MALE )
        {
            [_imgCharacter setImage:[UIImage imageNamed:@"man03.png"]];
        }
        else
        {
            [_imgCharacter setImage:[UIImage imageNamed:@"woman03.png"]];
        }
        
        [_imgBg setImage:[UIImage imageNamed:@"resultBG03.png"]];
    }

    if ( ! isWin )
    {
        [_btnNext setEnabled:NO];
        return;
    }

    int cMissionCode    = [[Mission getObject] getCurrentMissionCode];
    int maxMissionCode  = [[Mission getObject] getMissionCount];
    if ( cMissionCode < (maxMissionCode-1) )
    {
        [_btnNext setEnabled:YES];
    }
    else
    {
        [_btnNext setEnabled:NO];
    }
}

- (void)dealloc {
    [_imgCharacter release];
    [_imgWinLabel release];
    [_imgScoreBg release];
    [_btnRestart release];
    [_btnNext release];
    [_imgBg release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImgCharacter:nil];
    [self setImgWinLabel:nil];
    [self setImgScoreBg:nil];
    [self setBtnRestart:nil];
    [self setBtnNext:nil];
    [self setImgBg:nil];
    [super viewDidUnload];
}

@end
