//
//  SKLruDictionary.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruTable.h"

@interface SKLruTable () <SKLruListCoster, SKLruListSpiller>

@property(nonatomic, copy, readonly, nonnull) NSMutableDictionary *storage;
@property(nonatomic, copy, readonly, nonnull) SKLruList *keyLruList;
@property(nonatomic, weak, readonly, nullable) id<SKLruTableCoster> coster;
@property(nonatomic, weak, readonly, nullable) id<SKLruTableSpiller> spiller;

- (void)onSpilled:(id)object;

@end

@implementation SKLruTable

- (nonnull instancetype)initWithStorage:(nonnull NSMutableDictionary *)storage andLruList:(nonnull SKLruList *)lruList andCoster:(nonnull id<SKLruTableCoster>)coster andSpiller:(nullable id<SKLruTableSpiller>)spiller {
    self = [super init];
    
    _storage = storage;
    _keyLruList = lruList;
    _keyLruList.coster = self;
    _keyLruList.spiller = self;
    _coster = coster;
    _spiller = spiller;
    
    return self;
}

- (NSUInteger)count {
    return [_storage count];
}

- (NSUInteger)cost {
    return _keyLruList.cost;
}

- (NSUInteger)constraint {
    return _keyLruList.constraint;
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_storage removeAllObjects];
        [_keyLruList removeAllObjects];
    }
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        id object = [_storage objectForKey:key];
        if(object) {
            [_keyLruList touchObject:key];
        }
        return object;
    }
}

- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_storage setObject:object forKey:key];
        [_keyLruList touchObject:key];
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_storage removeObjectForKey:key];
        [_keyLruList removeObject:key];
    }
}

#pragma mark - SKLruListSpiller

- (NSUInteger)costForObject:(id)key {
    id object = [_storage objectForKey:key];
    return [_coster costForObject:object];
}

- (void)onSpilled:(id)key {
    @synchronized(self) {
        id object = [_storage objectForKey:key];
        [_storage removeObjectForKey:key];
        if([_spiller respondsToSelector:@selector(onSpilled:forKey:)]) {
            [_spiller onSpilled:object forKey:key];
        }
    }
}

@end
