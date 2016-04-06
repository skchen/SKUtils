//
//  SKLruStorage.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruStorage.h"

@interface SKLruStorage () <SKLruCoster, SKLruTableSpiller>

@property(nonatomic, copy, readonly, nonnull) NSFileManager *fileManager;
@property(nonatomic, copy, readonly, nonnull) SKLruTable *urlLruTable;

@end

@implementation SKLruStorage

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class SKLruStorage"
                                 userInfo:nil];
}

- (nonnull instancetype)initWithStorage:(NSMutableDictionary *)storage andLruList:(SKLruList *)lruList andCoster:(id<SKLruCoster>)coster andSpiller:(id<SKLruTableSpiller>)spiller {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-initWithStorage:andLruList:andCoster:andSpiller is not a valid initializer for the class SKLruStorage"
                                 userInfo:nil];
}

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andLruTable:(nonnull SKLruTable *)lruTable andCoster:(nonnull id<SKLruCoster>)coster andSpiller:(nonnull id<SKLruTableSpiller>)spiller {
    
    self = [super init];
    
    _fileManager = fileManager;
    _urlLruTable = lruTable;
    _urlLruTable.coster = self;
    _urlLruTable.spiller = self;
    
    _coster = coster;
    _spiller = spiller;
    
    return self;
}

- (NSUInteger)count {
    return _urlLruTable.count;
}

- (NSUInteger)cost {
    return _urlLruTable.cost;
}

- (NSUInteger)constraint {
    return _urlLruTable.constraint;
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    NSURL *url = [_urlLruTable objectForKey:key];
    if(url) {
        if([_fileManager fileExistsAtPath:[url absoluteString]]) {
            return url;
        } else {
            [_urlLruTable removeObjectForKey:key];
        }
    }
    
    return nil;
}

- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    NSURL *url = (NSURL *)object;
    if([_fileManager fileExistsAtPath:[url absoluteString]]) {
        [_urlLruTable setObject:url forKey:key];
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    NSURL *url = [_urlLruTable objectForKey:key];
    [_urlLruTable removeObjectForKey:key];
    
    if(url) {
        [_fileManager removeItemAtURL:url error:nil];
    }
}

- (void)removeAllObjects {
    NSArray *urls = [_urlLruTable allValues];
    for(NSURL *url in urls) {
        [_fileManager removeItemAtURL:url error:nil];
    }
    [_urlLruTable removeAllObjects];
}

#pragma mark - SKLruTableCoster

- (NSUInteger)costForObject:(id)object {
    return [_coster costForObject:object];
}

#pragma mark - SKLruTableSpiller

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        NSURL *url = (NSURL *)object;
        [_fileManager removeItemAtURL:url error:nil];
        [_spiller onSpilled:object forKey:key];
    }
}

@end
