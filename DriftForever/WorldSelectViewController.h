//
//  MissionSelectViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/29/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol WorldSelectViewDelegate <NSObject>

- (void) onSelectWorld: (id) sender;
- (void) onBack: (id) sender;

@end

@interface WorldSelectViewController : UIViewController

@property (assign) id<WorldSelectViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIImageView *imgWorld;
@property (retain, nonatomic) IBOutlet UIButton *btnPrevWorld;
@property (retain, nonatomic) IBOutlet UIButton *btnNextWorld;
@property (retain, nonatomic) IBOutlet UIButton *btnSelectWorld;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)onPressPrevWorld:(id)sender;
- (IBAction)onPressNextWorld:(id)sender;

- (IBAction)onPressSelectWorld:(id)sender;
- (IBAction)onPressBackButton:(id)sender;

@end
