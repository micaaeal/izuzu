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

- (void) initDataByHand;

- (IBAction)onSelectMission:(id)sender;
- (IBAction)onBack:(id)sender;

@end
