//
//  SKLruStorage.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruTable.h"

@protocol SKLruStorageCoster <NSObject>

- (NSUInteger)costForObject:(nonnull id)object;

@end

@protocol SKLruStorageSpiller <NSObject>

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

@end

@interface SKLruStorage : NSObject

@property(nonatomic, assign, readonly) NSUInteger count;

@property(nonatomic, assign, readonly) NSUInteger constraint;
@property(nonatomic, assign, readonly) NSUInteger cost;

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andLruTable:(nonnull SKLruTable *)lruTable andCoster:(nonnull id<SKLruStorageCoster>)coster andSpiller:(nullable id<SKLruStorageSpiller>)spiller;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;
- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeAllObjects;

@end
