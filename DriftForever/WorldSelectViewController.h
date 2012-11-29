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

- (IBAction)onPressSelectWorld:(id)sender;
- (IBAction)onPressBackButton:(id)sender;

@end
