//
//  Order.m
//  DriftForever
//
//  Created by Adawat Chanchua on 12/14/55 BE.
//
//

#import "Order.h"

#import <vector>
using namespace std;

@interface Order()
@property (assign) vector<CGPoint>  positions;
@end

@implementation Order
@synthesize positions;

- (id) init
{
    self    = [super init];
    if (self)
    {
        positions.clear();
    }
    return self;
}

- (void) addOrderAtPosition: (CGPoint) position
{
    positions.push_back(position);
}
- (int) getOrderCount
{
    return positions.size();
}
- (CGPoint*) getOrderPositionArray
{
    return &positions.front();
}

@end
