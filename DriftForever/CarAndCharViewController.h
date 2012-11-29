//
//  CarAndCharViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 11/28/55 BE.
//
//

#import <UIKit/UIKit.h>

@protocol CarAndCharViewDelegate <NSObject>

- (void) onNext: (id) sender;

@end

@interface CarAndCharViewController : UIViewController

@property (assign) id<CarAndCharViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *txtPlayerName;

- (IBAction)onPressOKButton:(id)sender;
- (IBAction)onTouchRootView:(id)sender;

@end
