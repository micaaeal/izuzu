//
//  WinMenuViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/10/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol WinLostMenuViewDelegate <NSObject>

- (void) onRestart: (id) sender;
- (void) onNext: (id) sender;
- (void) onShare: (id) sender;

@end

@interface WinLostMenuViewController : UIViewController

@property (assign) id<WinLostMenuViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIImageView *imgBg;
@property (retain, nonatomic) IBOutlet UIImageView *imgCharacter;
@property (retain, nonatomic) IBOutlet UIImageView *imgWinLabel;
@property (retain, nonatomic) IBOutlet UIImageView *imgScoreBg;

@property (retain, nonatomic) IBOutlet UIButton *btnRestart;

@property (retain, nonatomic) IBOutlet UIButton *btnNext;

@property (retain, nonatomic) IBOutlet UILabel *txtScore;

- (IBAction)onShare:(id)sender;
- (IBAction)onRestart:(id)sender;
- (IBAction)onNext:(id)sender;

- (void) initDataByHand: (id) sender isWin: (BOOL) isWin;

@end
