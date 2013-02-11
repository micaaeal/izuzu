//
//  MissionSelectViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import "MissionSelectViewController.h"
#import "Mission.h"
#import "SaveLoadData.h"
#import "Score.h"

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

- (void)dealloc
{
    [_btnMission01 release];
    [_btnMission02 release];
    [_btnMission03 release];
    [_btnMission04 release];
    [_btnMission05 release];
    [_btnBack release];
    [_btn_m01_l release];
    [_btn_m01_e release];
    [_btn_m01_h release];
    [_btn_m02_l release];
    [_btn_m02_e release];
    [_btn_m02_h release];
    [_btn_m03_l release];
    [_btn_m03_e release];
    [_btn_m03_h release];
    [_btn_m04_l release];
    [_btn_m04_e release];
    [_btn_m04_h release];
    [_btn_m05_l release];
    [_btn_m05_e release];
    [_btn_m05_h release];
    [_imgMissionLock01 release];
    [_imgMissionLock02 release];
    [_imgMissionLock03 release];
    [_imgMissionLock04 release];
    [_imgMissionLock05 release];
    [super dealloc];
}

- (void) initDataByHand
{
    NSMutableArray* missionBtnArray = [[NSMutableArray alloc] init];
    [missionBtnArray addObject:_btnMission01];
    [missionBtnArray addObject:_btnMission02];
    [missionBtnArray addObject:_btnMission03];
    [missionBtnArray addObject:_btnMission04];
    [missionBtnArray addObject:_btnMission05];
    
    // disable all image button
    for ( int i=0; i<missionBtnArray.count; ++i )
    {
        UIButton* cBtn = [missionBtnArray objectAtIndex:i];
        [cBtn setEnabled:NO];
    }
    UIButton* cBtn = [missionBtnArray objectAtIndex:0];
    [cBtn setEnabled:YES];
    
    NSMutableArray* missionMedalArray = [[NSMutableArray alloc] init];
    [missionMedalArray addObject:_btn_m01_l];
    [missionMedalArray addObject:_btn_m01_e];
    [missionMedalArray addObject:_btn_m01_h];
    [missionMedalArray addObject:_btn_m02_l];
    [missionMedalArray addObject:_btn_m02_e];
    [missionMedalArray addObject:_btn_m02_h];
    [missionMedalArray addObject:_btn_m03_l];
    [missionMedalArray addObject:_btn_m03_e];
    [missionMedalArray addObject:_btn_m03_h];
    [missionMedalArray addObject:_btn_m04_l];
    [missionMedalArray addObject:_btn_m04_e];
    [missionMedalArray addObject:_btn_m04_h];
    [missionMedalArray addObject:_btn_m05_l];
    [missionMedalArray addObject:_btn_m05_e];
    [missionMedalArray addObject:_btn_m05_h];
    
    // hide all medal
    for ( int i=0; i<missionMedalArray.count; ++i )
    {
        UIImageView* cMedal = [missionMedalArray objectAtIndex:i];
        [cMedal setAlpha:0.0f];
    }
    
    NSMutableArray* missionLockArray    = [[NSMutableArray alloc] init];
    [missionLockArray addObject:_imgMissionLock01];
    [missionLockArray addObject:_imgMissionLock02];
    [missionLockArray addObject:_imgMissionLock03];
    [missionLockArray addObject:_imgMissionLock04];
    [missionLockArray addObject:_imgMissionLock05];
    
    // show all mission locks
    for ( int i=0; i<missionLockArray.count; ++i )
    {
        UIImageView* cLock = [missionLockArray objectAtIndex:i];
        [cLock setAlpha:1.0f];
    }
    
    UIImageView* mLock01    = [missionLockArray objectAtIndex:0];
    [mLock01 setAlpha:0.0f];
    
    NSDictionary* cLevelDict = [[SaveLoadData getObject] loadSavedLevel];
    
    for ( NSString* cKey in cLevelDict )
    {
        int cMissionCode    = cKey.intValue;
        
        NSDictionary* cLevel    = [cLevelDict objectForKey:cKey];
        NSString* cMissionScore = [cLevel objectForKey:@"mission_score"];
        int missionScoreInt     = [cMissionScore integerValue];
        
        enum SCORE_LEVEL cScoreLevel    = [[Score getObject] getScoreLevelFromScore:missionScoreInt];

        int cMedalBaseIndex     = cMissionCode * 3;
        switch (cScoreLevel) {
            case SCORE_LEVEL_HIGH:
            {
                UIImageView* cImgView   = [missionMedalArray objectAtIndex:cMedalBaseIndex];
                [cImgView setAlpha:1.0f];
                cImgView    = [missionMedalArray objectAtIndex:cMedalBaseIndex+1];
                [cImgView setAlpha:1.0f];
                cImgView    = [missionMedalArray objectAtIndex:cMedalBaseIndex+2];
                [cImgView setAlpha:1.0f];
            }
                break;
            case SCORE_LEVEL_EVERAGE:
            {
                UIImageView* cImgView   = [missionMedalArray objectAtIndex:cMedalBaseIndex];
                [cImgView setAlpha:1.0f];
                cImgView    = [missionMedalArray objectAtIndex:cMedalBaseIndex+1];
                [cImgView setAlpha:1.0f];
            }
                break;
            case SCORE_LEVEL_LOW:
            {
                UIImageView* cImgView   = [missionMedalArray objectAtIndex:cMedalBaseIndex];
                [cImgView setAlpha:1.0f];
            }
                break;
            default:
            {
                // do nothing
            }
                break;
        }
        
        // hide mission locks
        int cMUnlockIndex = cMissionCode + 1;
        if ( cMUnlockIndex >= missionLockArray.count )
        {
            cMUnlockIndex = cMissionCode;
        }
        
        // enable buttons
        UIButton* cBtn = [missionBtnArray objectAtIndex:cMUnlockIndex];
        [cBtn setEnabled:YES];
        
        // hide locks
        UIImageView* cMUnlockImg    = [missionLockArray objectAtIndex:cMUnlockIndex];
        [cMUnlockImg setAlpha:0.0f];
    }
    
    [missionLockArray release];
    missionLockArray    = nil;
    [missionMedalArray release];
    missionMedalArray   = nil;
    [missionBtnArray release];
    missionBtnArray = nil;
}

- (void)viewDidUnload {
    [self setBtnMission01:nil];
    [self setBtnMission02:nil];
    [self setBtnMission03:nil];
    [self setBtnMission04:nil];
    [self setBtnMission05:nil];
    [self setBtnBack:nil];
    [self setBtn_m01_l:nil];
    [self setBtn_m01_e:nil];
    [self setBtn_m01_h:nil];
    [self setBtn_m02_l:nil];
    [self setBtn_m02_e:nil];
    [self setBtn_m02_h:nil];
    [self setBtn_m03_l:nil];
    [self setBtn_m03_e:nil];
    [self setBtn_m03_h:nil];
    [self setBtn_m04_l:nil];
    [self setBtn_m04_e:nil];
    [self setBtn_m04_h:nil];
    [self setBtn_m05_l:nil];
    [self setBtn_m05_e:nil];
    [self setBtn_m05_h:nil];
    [self setImgMissionLock01:nil];
    [self setImgMissionLock02:nil];
    [self setImgMissionLock03:nil];
    [self setImgMissionLock04:nil];
    [self setImgMissionLock05:nil];
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
