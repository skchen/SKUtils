//
//  SKOrderedDictionary.m
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/28.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKOrderedDictionary.h"

@interface SKOrderedDictionary ()

@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property(nonatomic, strong) NSMutableArray *array;

@end

@implementation SKOrderedDictionary

- (instancetype)init {
    self = [super init];
    _dictionary = [[NSMutableDictionary alloc] init];
    _array = [[NSMutableArray alloc] init];
    return self;
}

- (NSUInteger)count {
    @synchronized(self) {
        return [_dictionary count];
    }
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        return [_dictionary objectForKey:key];
    }
}

- (nullable id)objectAtIndex:(NSUInteger)index {
    @synchronized(self) {
        id key = [_array objectAtIndex:index];
        return [_dictionary objectForKey:key];
    }
}

- (nullable id)lastObject {
    @synchronized(self) {
        id key = [_array lastObject];
        if(key) {
            return [_dictionary objectForKey:key];
        }
        return nil;
    }
}

- (void)insertObject:(nonnull id)object atIndex:(NSUInteger)index forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_dictionary setObject:object forKey:key];
        [_array removeObject:key];
        [_array insertObject:key atIndex:index];
    }
}

- (void)addObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_dictionary setObject:object forKey:key];
        if(![_array containsObject:key]) {
            [_array addObject:key];
        }
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        [_dictionary removeObjectForKey:key];
        [_array removeObject:key];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    @synchronized(self) {
        id key = [_array objectAtIndex:index];
        [_dictionary removeObjectForKey:key];
        [_array removeObject:key];
    }
}

- (void)removeLastObject {
    @synchronized(self) {
        id<NSCopying> key = [_array lastObject];
        if(key) {
            [_array removeObject:key];
            [_dictionary removeObjectForKey:key];
        }
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_dictionary removeAllObjects];
        [_array removeAllObjects];
    }
}

@end
