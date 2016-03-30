//
//  SKLruDictionary.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKLruCacheSpiller <NSObject>

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

@end

@interface SKLruCache : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

- (void)removeAllObjects;

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andSpiller:(nullable id<SKLruCacheSpiller>)spiller;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;
- (void)removeObjectForKey:(nonnull id<NSCopying>)key;

@end
