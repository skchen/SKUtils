//
//  SKLruCache.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruTable.h"

@protocol SKLruCacheLoader <NSObject>

- (nullable)loadObjectForKey:(nonnull id<NSCopying>)key;

@end

@interface SKLruCache : NSObject

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andLoader:(nonnull id<SKLruCacheLoader>)loader;
- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKLruCacheLoader>)loader;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeAllObjects;

@end
