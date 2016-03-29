//
//  SKLruDictionary.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLruCache : NSObject

@property (readonly) NSUInteger count;

- (void)removeAllObjects;

- (nonnull instancetype)initWithCapacity:(NSUInteger)numItems;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;
- (void)removeObjectForKey:(nonnull id<NSCopying>)key;

@end
