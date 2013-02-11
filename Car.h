//
//  Car.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Mission.h"

@interface Car : NSObject

@property (assign) BOOL     isPlayingAnyAnim;

+ (Car*) getObject;

- (BOOL) LoadData;
- (BOOL) UnloadData;

- (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission;
- (BOOL) UnSssignDataFromLayer: (CCLayer*) layer;

- (void) selectCarByIndex: (int) carIndex;

- (void) Update: (float) deltaTime;

// properties
- (float) getSpeed;
- (void) setSpeed: (float) speed;

- (void) setPosition: (CGPoint) position;
- (void) setTarget: (CGPoint) target;
- (const CGPoint) getPosition;
- (const CGFloat) getRotation;
- (const CGPoint) getTarget;
- (const CGPoint) getDirectionUnitVec;
- (void) resetCarToTarget;

- (CGRect) getBoundingBox;

// texture
- (void) hideCar;
- (void) showCar;

// events
- (void) setRandomColor;
- (void) unsetRandomColor;

// picked up functions
- (void) pickUpNothing;
- (void) pickUpBox;
- (void) pickUpRefrigerator;
- (void) pickUpSofa;

// animations
- (void) stopAllAnim;

- (void) playOvershootAnim;
- (void) stopOvershootAnim;

- (void) playSwerveAnim;
- (void) stopSwerveAnim;

- (void) playRoughAnim;
- (void) stopRoughAnim;

- (void) playTutleEffect;
- (void) stopTutleEffect;

- (void) playSpeedLine;
- (void) stopSpeedLine;

- (void) playBlinkWithTime: (float) blinkTime;

@end
