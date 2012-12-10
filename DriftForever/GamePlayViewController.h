//
//  GamePlayViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import <UIKit/UIKit.h>
#import "PauseMenuViewController.h"
#import "RestartMenuViewController.h"
#import "WinLostMenuViewController.h"

@class PlayDriftLayer;
@interface GamePlayViewController : UIViewController <PauseMenuViewDelegate, RestartMenuViewDelegate, WinLostMenuViewDelegate>

@property (assign) PlayDriftLayer*  playDriftLayer;
@property (retain, nonatomic) IBOutlet PauseMenuViewController *pauseMenuViewController;
@property (retain, nonatomic) IBOutlet RestartMenuViewController *restartMenuViewController;
@property (retain, nonatomic) IBOutlet WinLostMenuViewController *winMenuViewController;

@property (retain, nonatomic) IBOutlet UIButton *btnPause;

- (IBAction)onPause:(id)sender;
- (IBAction) onWin: (id) sender;
- (IBAction) onLost: (id) sender;

@end
