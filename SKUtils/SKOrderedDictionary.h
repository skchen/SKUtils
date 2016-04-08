//
//  SKOrderedDictionary.h
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/28.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKOrderedDictionary : NSObject

@property (readonly) NSUInteger count;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (nullable id)objectAtIndex:(NSUInteger)index;
- (nullable id)lastObject;

- (void)insertObject:(nonnull id)object atIndex:(NSUInteger)index forKey:(nonnull id<NSCopying>)key;
- (void)addObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeAllObjects;

@end
