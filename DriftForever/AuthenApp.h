//
//  AuthenViewController.h
//  DriftForever
//
//  Created by Adawat Chanchua on 4/1/56 BE.
//
//

#import <UIKit/UIKit.h>

@protocol AuthenAppDelegate <NSObject>

- (void) onAuthenSuccess: (id) sender;
- (void) onAuthenFailed: (id) sender;

@end

@interface AuthenApp : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (assign) id<AuthenAppDelegate> delegate;

- (void) startAppAuthen;

@end
