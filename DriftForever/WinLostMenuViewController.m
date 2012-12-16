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

#import "Score.h"

#import <FacebookSDK/FacebookSDK.h>
#import "social/Social.h"
#import "accounts/Accounts.h"

@interface WinLostMenuViewController () <FBLoginViewDelegate>

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

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}

- (IBAction)onShare:(id)sender {
    
    // Facebook onShare
    NSString* missionCode   = [[NSString alloc] initWithFormat:@"%d", [[Mission getObject] getCurrentMissionCode]];
    NSString* missionScore  = [[NSString alloc] initWithFormat:@"%ld", [[Score getObject] calculateScore]];
    NSString *message = [NSString stringWithFormat:@"I got %@ for mission %@", missionScore, missionCode];
    
    // post wall for iOS 6
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 5.99999 )
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    NSLog(@"Done");
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            
            [controller setInitialText:message];
            [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
            [controller addImage:[UIImage imageNamed:@"startMenuPart01.png"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            NSLog(@"UnAvailable");
        }
    }
    else // posted wall for iOS 5
    {
        
    }
    
    // delegate
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
        long score  = [[Score getObject] calculateScore];
        NSString* scoreStr  = [[NSString alloc] initWithFormat:@"%ld", score];
        _txtScore.text      = scoreStr;
        [scoreStr release];
        scoreStr    = nil;
        
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
        _txtScore.text  = @"0";
        
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
    [_txtScore release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImgCharacter:nil];
    [self setImgWinLabel:nil];
    [self setImgScoreBg:nil];
    [self setBtnRestart:nil];
    [self setBtnNext:nil];
    [self setImgBg:nil];
    [self setTxtScore:nil];
    [super viewDidUnload];
}

@end
