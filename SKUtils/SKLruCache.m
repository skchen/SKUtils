//
//  SKLruDictionary.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruCache.h"

@interface SKLruCache ()

@property(nonatomic, assign, readonly) NSUInteger capacity;
@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property(nonatomic, strong) NSMutableArray *array;

- (void)_removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)checkOverflow;
- (BOOL)isOverflow;

@end

@implementation SKLruCache

- (nonnull instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    _capacity = numItems;
    _dictionary = [[NSMutableDictionary alloc] initWithCapacity:(numItems+1)];
    _array = [[NSMutableArray alloc] initWithCapacity:(numItems+1)];
    return self;
}

- (NSUInteger)count {
    return [_dictionary count];
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_dictionary removeAllObjects];
        [_array removeAllObjects];
    }
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        id object = [_dictionary objectForKey:key];
        
        [_array removeObject:key];
        [_array insertObject:key atIndex:0];
        
        return object;
    }
}

- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    
    @synchronized(self) {
        [_dictionary setObject:object forKey:key];
        
        [_array removeObject:key];
        [_array insertObject:key atIndex:0];
        
        [self checkOverflow];
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [self _removeObjectForKey:key];
    }
}

- (void)_removeObjectForKey:(nonnull id<NSCopying>)key {
    [_dictionary removeObjectForKey:key];
    
    [_array removeObject:key];
}

- (void)checkOverflow {
    if([self isOverflow]) {
        id<NSCopying> key = [_array lastObject];
        [self _removeObjectForKey:key];
    }
}

- (BOOL)isOverflow {
    return ([_dictionary count]>_capacity);
}

@end
