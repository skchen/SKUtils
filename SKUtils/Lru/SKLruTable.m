//
//  SKLruDictionary.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruTable.h"

#import "SKLruList.h"

@interface SKLruTable () <SKLruListCoster, SKLruListSpiller>

@property(nonatomic, assign, readonly) NSUInteger capacity;
@property(nonatomic, weak, readonly, nullable) id<SKLruTableCoster> coster;
@property(nonatomic, weak, readonly, nullable) id<SKLruTableSpiller> spiller;
@property(nonatomic, copy, readonly, nonnull) NSMutableDictionary *dictionary;
@property(nonatomic, copy, readonly, nonnull) SKLruList *keyLruList;

- (void)onSpilled:(id)object;

@end

@implementation SKLruTable

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andCoster:(nonnull id<SKLruTableCoster>)coster andSpiller:(nullable id<SKLruTableSpiller>)spiller {
    self = [super init];
    _capacity = capacity;
    _coster = coster;
    _spiller = spiller;
    _dictionary = [[NSMutableDictionary alloc] init];
    _keyLruList = [[SKLruList alloc] initWithConstraint:capacity andStorage:[[NSMutableArray alloc] init] andCoster:self andSpiller:self];
    return self;
}

- (NSUInteger)count {
    return [_dictionary count];
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_dictionary removeAllObjects];
        [_keyLruList removeAllObjects];
    }
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        id object = [_dictionary objectForKey:key];
        if(object) {
            [_keyLruList touchObject:key];
        }
        return object;
    }
}

- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_dictionary setObject:object forKey:key];
        [_keyLruList touchObject:key];
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_dictionary removeObjectForKey:key];
        [_keyLruList removeObject:key];
    }
}

#pragma mark - SKLruListSpiller

- (NSUInteger)costForObject:(id)key {
    id object = [_dictionary objectForKey:key];
    return [_coster costForObject:object];
}

- (void)onSpilled:(id)key {
    @synchronized(self) {
        id object = [_dictionary objectForKey:key];
        [_dictionary removeObjectForKey:key];
        if([_spiller respondsToSelector:@selector(onSpilled:forKey:)]) {
            [_spiller onSpilled:object forKey:key];
        }
    }
}

@end
