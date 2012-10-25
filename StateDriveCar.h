//
//  StateDriveCar.h
//  DriftForever
//
//  Created by Adawat Chanchua on 9/29/55 BE.
//
//

#import <Foundation/Foundation.h>
#import "StateProtocol.h"
#import "EventHandler.h"
#import "ComboPlayer.h"
#import "Console.h"

@interface StateDriveCar : NSObject <StateProtocol, EventHandlerDelegate, ComboPlayerDelegate, ConsoleDelegate>

@end