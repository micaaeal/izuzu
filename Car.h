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

+ (BOOL) LoadData;
+ (BOOL) UnloadData;

+ (BOOL) AssignDataToLayer: (CCLayer*) layer withMission: (Mission*) mission;
+ (BOOL) UnSssignDataFromLayer: (CCLayer*) layer;

+ (void) Update: (float) deltaTime;

// properties
+ (float) getSpeed;
+ (void) setSpeed: (float) speed;

+ (void) setPosition: (CGPoint) position;
+ (void) setTarget: (CGPoint) target;
+ (const CGPoint) getPosition;
+ (const CGFloat) getRotation;
+ (const CGPoint) getTarget;
+ (const CGPoint) getDirectionUnitVec;

+ (CGRect) getBoundingBox;

// texture
+ (void) hideCar;
+ (void) showCar;

// events
+ (void) setRandomColor;
+ (void) unsetRandomColor;

// animations
+ (BOOL) isPlayingAnyAnim;
+ (void) stopAllAnim;

+ (void) playOvershootAnim;
+ (BOOL) isPlayingOvershootAnim;
+ (void) stopOvershootAnim;

+ (void) playSwerveAnim;
+ (BOOL) isPlayingSwerveAnim;
+ (void) stopSwerveAnim;

+ (void) playRoughAnim;
+ (BOOL) isPlayingRoughAnim;
+ (void) stopRoughAnim;

+ (void) playTutleEffect;
+ (BOOL) isPlayTutleEffect;
+ (void) stopTutleEffect;

+ (void) playSpeedLine;
+ (BOOL) isPlayingSpeedLine;
+ (void) stopSpeedLine;

+ (void) playBlinkWithTime: (float) blinkTime;

@end
