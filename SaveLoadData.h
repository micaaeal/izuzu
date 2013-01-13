//
//  SaveLoadData.h
//  DriftForever
//
//  Created by Adawat Chanchua on 1/13/56 BE.
//
//

#import <Foundation/Foundation.h>

@interface SaveLoadData : NSObject

+ (SaveLoadData*) getObject;

- (NSDictionary*) loadSavedLevel;
- (void) SaveLevel: (NSDictionary*) levelData;

@end
