//
//  Order.h
//  DriftForever
//
//  Created by Adawat Chanchua on 12/14/55 BE.
//
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

- (void) addOrderAtPosition: (CGPoint) position;
- (int) getOrderCount;
- (CGPoint*) getOrderPositionArray;

@end
