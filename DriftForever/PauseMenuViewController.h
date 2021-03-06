//
//  PauseMenuViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol PauseMenuViewDelegate <NSObject>

- (void) onResume: (id) sender;
- (void) onRetry: (id) sender;
- (void) onExit: (id) sender;

@end

@interface PauseMenuViewController : UIViewController

@property (assign) id<PauseMenuViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *btnResume;
@property (retain, nonatomic) IBOutlet UIButton *btnRetry;
@property (retain, nonatomic) IBOutlet UIButton *btnExit;

- (IBAction)onResume:(id)sender;
- (IBAction)onRetry:(id)sender;
- (IBAction)onExit:(id)sender;

@end
