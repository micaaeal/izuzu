//
//  SaveLoadData.m
//  DriftForever
//
//  Created by Adawat Chanchua on 1/13/56 BE.
//
//

#import "SaveLoadData.h"

SaveLoadData* _s_objectSaveLoad = nil;

@interface SaveLoadData()

@property (copy) NSString*  fileName;
@property (retain) NSDictionary*    currentSavedLevel;

@end

@implementation SaveLoadData

+ (SaveLoadData*) getObject
{
    if ( ! _s_objectSaveLoad )
    {
        _s_objectSaveLoad   = [[SaveLoadData alloc] init];
        _s_objectSaveLoad.fileName   = [[NSString alloc] initWithFormat:@"levelFile"];
        _s_objectSaveLoad.currentSavedLevel  = nil;
    }
    
    return _s_objectSaveLoad;
}

- (NSDictionary*) loadSavedLevel
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:_fileName];

    if ( _currentSavedLevel )
    {
        [_currentSavedLevel release];
        _currentSavedLevel  = nil;
    }
    NSDictionary* cSavedLevel   = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    _currentSavedLevel  = cSavedLevel;
    [_currentSavedLevel retain];
    [cSavedLevel release];
    cSavedLevel = nil;
    
    return _currentSavedLevel;
}

- (NSDictionary*) loadSavedLevelByKey: (NSString*) key
{
    NSDictionary* savedLevelDict    = [self loadSavedLevel];
    return [savedLevelDict objectForKey:key];
}

- (void) SaveLevelData: (NSDictionary*) data andKey: (NSString*) key
{
    // load from file
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:_fileName];
    
    if ( _currentSavedLevel )
    {
        [_currentSavedLevel release];
        _currentSavedLevel  = nil;
    }
    NSMutableDictionary* cSavedLevel   = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    _currentSavedLevel  = cSavedLevel;
    [_currentSavedLevel retain];
    [cSavedLevel release];
    cSavedLevel = nil;
    
    if ( ! _currentSavedLevel )
    {
        _currentSavedLevel = [[NSMutableDictionary alloc] init];
    }
    
    // append key
    [(NSMutableDictionary*)_currentSavedLevel setObject:data forKey:key];
    
    // save to file
    [_currentSavedLevel writeToFile:filePath atomically:NO];
}

@end
