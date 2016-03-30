//
//  SKLruDictionary.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruCache.h"

#import "SKLruList.h"

@interface SKLruCache () <SKLruListSpiller>

@property(nonatomic, assign, readonly) NSUInteger capacity;
@property(nonatomic, copy, readonly, nonnull) NSMutableDictionary *dictionary;
@property(nonatomic, copy, readonly, nonnull) SKLruList *keyLruList;

- (void)onSpilled:(id)object;

@end

@implementation SKLruCache

- (nonnull instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    _capacity = numItems;
    _dictionary = [[NSMutableDictionary alloc] initWithCapacity:(numItems+1)];
    _keyLruList = [[SKLruList alloc] initWithCapacity:numItems andSpiller:self];
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

- (void)onSpilled:(id)object {
    @synchronized(self) {
        [_dictionary removeObjectForKey:object];
    }
}

@end
