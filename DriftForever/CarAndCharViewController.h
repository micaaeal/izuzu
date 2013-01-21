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

@interface CarAndCharViewController : UIViewController <UITextFieldDelegate>

@property (assign) id<CarAndCharViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *txtPlayerName;

@property (retain, nonatomic) IBOutlet UIButton *btnMale;
@property (retain, nonatomic) IBOutlet UIButton *btnFemale;
@property (retain, nonatomic) IBOutlet UIButton *btnCarPrev;
@property (retain, nonatomic) IBOutlet UIButton *btnCarNext;

@property (retain, nonatomic) IBOutlet UIImageView *imgCar;
@property (retain, nonatomic) IBOutlet UIImageView *imgCharacter;

@property (retain, nonatomic) IBOutlet UIButton *btnOK;

- (void) initDataByHand:(id)sender;

- (IBAction)onPressFemale:(id)sender;
- (IBAction)onPressMale:(id)sender;
- (IBAction)onPressCarPrev:(id)sender;
- (IBAction)onPressCarNext:(id)sender;

- (IBAction)onPressOKButton:(id)sender;
- (IBAction)onTouchRootView:(id)sender;

@end
