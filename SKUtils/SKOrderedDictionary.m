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
    return [_dictionary count];
}

- (void)removeAllObjects {
    [_dictionary removeAllObjects];
    [_array removeAllObjects];
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    return [_dictionary objectForKey:key];
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    [_dictionary removeObjectForKey:key];
    [_array removeObject:key];
}

- (nullable id)objectAtIndex:(NSUInteger)index {
    id key = [_array objectAtIndex:index];
    return [_dictionary objectForKey:key];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    id key = [_array objectAtIndex:index];
    [_dictionary removeObjectForKey:key];
    [_array removeObject:key];
}

- (void)insertObject:(nonnull id)object atIndex:(NSUInteger)index forKey:(nonnull id<NSCopying>)key {
    [_dictionary setObject:object forKey:key];
    [_array removeObject:key];
    [_array insertObject:key atIndex:index];
}

- (void)addObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    [_dictionary setObject:object forKey:key];
    [_array removeObject:key];
    [_array addObject:key];
}

@end
