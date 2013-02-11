//
//  MissionSelectViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol MissionSelectViewDelegate <NSObject>

- (void) onBack: (id) sender;
- (void) onSelectMission: (id) sender;

@end

@interface MissionSelectViewController : UIViewController

@property (assign) id<MissionSelectViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *btnBack;

@property (retain, nonatomic) IBOutlet UIButton *btnMission01;
@property (retain, nonatomic) IBOutlet UIButton *btnMission02;
@property (retain, nonatomic) IBOutlet UIButton *btnMission03;
@property (retain, nonatomic) IBOutlet UIButton *btnMission04;
@property (retain, nonatomic) IBOutlet UIButton *btnMission05;

@property (retain, nonatomic) IBOutlet UIImageView *btn_m01_l;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m01_e;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m01_h;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m02_l;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m02_e;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m02_h;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m03_l;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m03_e;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m03_h;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m04_l;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m04_e;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m04_h;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m05_l;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m05_e;
@property (retain, nonatomic) IBOutlet UIImageView *btn_m05_h;

@property (retain, nonatomic) IBOutlet UIImageView *imgMissionLock01;
@property (retain, nonatomic) IBOutlet UIImageView *imgMissionLock02;
@property (retain, nonatomic) IBOutlet UIImageView *imgMissionLock03;
@property (retain, nonatomic) IBOutlet UIImageView *imgMissionLock04;
@property (retain, nonatomic) IBOutlet UIImageView *imgMissionLock05;

- (void) initDataByHand;

- (IBAction)onSelectMission:(id)sender;
- (IBAction)onBack:(id)sender;

@end
