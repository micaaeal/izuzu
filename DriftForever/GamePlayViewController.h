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

@protocol GamePlayViewDelegate <NSObject>

- (void) onBack: (id) sender;
- (void) onErase: (id) sender;
- (void) onDraw: (id) sender;

- (void) onGoDrive: (id) sender;

- (void) onZoomIn: (id) sender;
- (void) onZoomOut: (id) sender;

@end

@class PlayDriftLayer;
@interface GamePlayViewController : UIViewController <PauseMenuViewDelegate, RestartMenuViewDelegate, WinLostMenuViewDelegate>

@property (assign) id<GamePlayViewDelegate> delegate;

@property (retain) PlayDriftLayer*  playDriftLayer;
@property (retain, nonatomic) IBOutlet PauseMenuViewController *pauseMenuViewController;
@property (retain, nonatomic) IBOutlet RestartMenuViewController *restartMenuViewController;
@property (retain, nonatomic) IBOutlet WinLostMenuViewController *winMenuViewController;

@property (retain, nonatomic) IBOutlet UIButton *btnPause;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIButton *btnErasePath;
@property (retain, nonatomic) IBOutlet UIButton *btnDrawPath;
@property (retain, nonatomic) IBOutlet UIButton *btnZoomIn;
@property (retain, nonatomic) IBOutlet UIButton *btnZoomOut;

- (void) initDataByHand: (id) sender;

- (IBAction)onPause:(id)sender;
- (IBAction) onWin: (id) sender;
- (IBAction) onLost: (id) sender;
- (IBAction)onOk:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onErase:(id)sender;
- (IBAction)onDraw:(id)sender;
- (IBAction)onZoomIn:(id)sender;
- (IBAction)onZoomOut:(id)sender;

- (void) onReadyToDrive: (id) sender;
- (void) onPathNotFinishYet: (id) sender;
- (void) bringUIViewToFront;

@end
