//
//  RestartMenuViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/9/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol RestartMenuViewDelegate <NSObject>

- (void) onResume: (id) sender;
- (void) onRestart: (id) sender;
- (void) onNewPath: (id) sender;

@end

@interface RestartMenuViewController : UIViewController

@property (assign) id<RestartMenuViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *btnResume;
@property (retain, nonatomic) IBOutlet UIButton *btnRestart;
@property (retain, nonatomic) IBOutlet UIButton *btnNewPath;

- (IBAction)onResume:(id)sender;
- (IBAction)onRestart:(id)sender;
- (IBAction)onNewPath:(id)sender;

@end
