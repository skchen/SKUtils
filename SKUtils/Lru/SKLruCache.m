//
//  SKLruCache.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruCache.h"

@interface SKLruCache ()

@property(nonatomic, strong, readonly, nonnull) SKLruTable *lruTable;
@property(nonatomic, weak, readonly) id<SKLruCacheLoader> loader;

@end

@implementation SKLruCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKLruCacheLoader>)loader {
    self = [super init];
    _lruTable = [[SKLruTable alloc] initWithConstraint:constraint andCoster:coster andSpiller:nil];
    _loader = loader;
    return self;
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andLoader:(nonnull id<SKLruCacheLoader>)loader {
    return [self initWithConstraint:constraint andCoster:nil andLoader:loader];
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    id object = [_lruTable objectForKey:key];
    if(!object) {
        object = [_loader loadObjectForKey:key];
        if(object) {
            [_lruTable setObject:object forKey:key];
        }
    }
    return object;
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    [_lruTable removeObjectForKey:key];
}

- (void)removeAllObjects {
    [_lruTable removeAllObjects];
}

@end
