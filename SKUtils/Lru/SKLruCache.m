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

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andLoader:(nonnull id<SKLruCacheLoader>)loader {
    self = [super init];
    _lruTable = lruTable;
    _loader = loader;
    return self;
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

@end
