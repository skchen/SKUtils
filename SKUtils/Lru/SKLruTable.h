//
//  SKLruDictionary.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruList.h"

@protocol SKLruTableSpiller <NSObject>

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

@end

@interface SKLruTable : NSObject {
    @protected
    NSUInteger _constraint;
    __weak id<SKLruCoster> _coster;
    __weak id<SKLruTableSpiller> _spiller;
}

@property(nonatomic, assign, readonly) NSUInteger count;

@property(nonatomic, assign, readonly) NSUInteger constraint;
@property(nonatomic, assign, readonly) NSUInteger cost;

@property(nonatomic, weak, nullable) id<SKLruCoster> coster;
@property(nonatomic, weak, nullable) id<SKLruTableSpiller> spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andSpiller:(nullable id<SKLruTableSpiller>)spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andSpiller:(nullable id<SKLruTableSpiller>)spiller;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

- (nonnull NSArray *)allValues;

- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeAllObjects;

@end
