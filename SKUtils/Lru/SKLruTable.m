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

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint {
    self = [super init];
    
    _storage = [[NSMutableDictionary alloc] init];
    
    _keyLruList = [[SKLruList alloc] initWithConstraint:constraint];
    _keyLruList.coster = self;
    _keyLruList.spiller = self;
    
    return self;
}

- (NSUInteger)constraint {
    return _keyLruList.constraint;
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

- (nonnull NSArray *)allKeys {
    return [_storage allKeys];
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

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    _storage = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:@"storage"];
    
    _keyLruList = [aDecoder decodeObjectOfClass:[SKLruList class] forKey:@"keyLruList"];
    _keyLruList.coster = self;
    _keyLruList.spiller = self;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_storage forKey:@"storage"];
    [aCoder encodeObject:_keyLruList forKey:@"keyLruList"];
}

#pragma mark - SKLruListCoster

- (NSUInteger)costForObject:(id)key {
    if(_coster) {
        id object = [_storage objectForKey:key];
        return [_coster costForObject:object];
    } else {
        return 1;
    }
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
