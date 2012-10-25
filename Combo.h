//
//  Combo.h
//  DriftForever
//
//  Created by Adawat Chanchua on 10/12/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Combo : Event

@property (retain) NSArray*     comboList;
@property (assign) CGPoint      comboVec;

@end
