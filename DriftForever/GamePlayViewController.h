//
//  GamePlayViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/6/55 BE.
//
//

#import <UIKit/UIKit.h>
#import "PauseMenuViewController.h"

@interface GamePlayViewController : UIViewController

@property (retain, nonatomic) IBOutlet PauseMenuViewController *pauseMenuViewController;

- (IBAction)onPause:(id)sender;

@end
