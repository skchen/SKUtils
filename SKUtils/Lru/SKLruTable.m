//
//  SKLruDictionary.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruTable.h"

@interface SKLruTable () <SKLruCoster, SKLruListSpiller>

@property(nonatomic, copy, readonly, nonnull) NSMutableDictionary *storage;
@property(nonatomic, copy, readonly, nonnull) SKLruList *keyLruList;

- (void)onSpilled:(id)object;

@end

@implementation SKLruTable

+ (id<SKLruCoster>)defaultCoster {
    return [[SKLruSimpleCoster alloc] init];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andSpiller:(nonnull id<SKLruTableSpiller>)spiller {
    self = [super init];
    
    _constraint = constraint;
    
    _storage = [[NSMutableDictionary alloc] init];
    
    _keyLruList = [[SKLruList alloc] initWithConstraint:constraint andCoster:self andSpiller:self];
    
    if(coster) {
        _coster = coster;
    } else {
        _coster = [SKLruTable defaultCoster];
    }
    
    _spiller = spiller;
    
    return self;
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andSpiller:(nullable id<SKLruTableSpiller>)spiller {
    return [self initWithConstraint:constraint andCoster:nil andSpiller:spiller];
}

- (NSUInteger)count {
    return _keyLruList.count;
}

- (NSUInteger)cost {
    return _keyLruList.cost;
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

- (nonnull NSArray *)allValues {
    return [_storage allValues];
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_storage removeObjectForKey:key];
        [_keyLruList removeObject:key];
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_storage removeAllObjects];
        [_keyLruList removeAllObjects];
    }
}

#pragma mark - SKLruListCoster

- (NSUInteger)costForObject:(id)key {
    id object = [_storage objectForKey:key];
    return [_coster costForObject:object];
}

#pragma mark - SKLruListSpiller

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
