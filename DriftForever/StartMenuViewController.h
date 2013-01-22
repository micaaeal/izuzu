//
//  StartMenuViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/28/55 BE.
//
//

#import <UIKit/UIKit.h>
#import "CarAndCharViewController.h"
#import "WorldSelectViewController.h"
#import "MissionSelectViewController.h"

@protocol StartMenuViewDelegate <NSObject>

- (void) onStartPlayingGame: (id) sender;

@end

@interface StartMenuViewController : UIViewController <CarAndCharViewDelegate, WorldSelectViewDelegate, MissionSelectViewDelegate>

@property (assign) id<StartMenuViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet CarAndCharViewController *carAndCharacterViewController;
@property (retain, nonatomic) IBOutlet WorldSelectViewController *worldSelectViewController;
@property (retain, nonatomic) IBOutlet MissionSelectViewController *missionViewController;

- (IBAction)onPressStartButton:(id)sender;
- (IBAction)onLoginToFacebook:(id)sender;

- (void)onGoMissionView:(id)sender;
- (void)onGoWorldView:(id)sender;

@end
