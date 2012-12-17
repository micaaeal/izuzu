//
//  FocusZoom.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/17/55 BE.
//
//

#import <Foundation/Foundation.h>

@interface FocusZoom : NSObject

+ (FocusZoom*) getObject;

- (int) getFocusPointIndex;
- (BOOL) getIsFocusing;
- (CGPoint) getFocusingPoint;
- (void) update: (float) dt;

@end
