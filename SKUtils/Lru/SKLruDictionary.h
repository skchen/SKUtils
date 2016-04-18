//
//  SKLruDictionary.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruArray.h"

@protocol SKLruTableSpiller <NSObject>

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

@end

@interface SKLruDictionary : NSObject <NSCoding> {
    @protected
    NSUInteger _constraint;
    id<SKLruCoster> _coster;
    __weak id<SKLruTableSpiller> _spiller;
}

@property(nonatomic, assign) NSUInteger constraint;

@property(nonatomic, assign, readonly) NSUInteger count;
@property(nonatomic, assign, readonly) NSUInteger cost;

@property(nonatomic, strong, nonnull) id<SKLruCoster> coster;
@property(nonatomic, weak, nullable) id<SKLruTableSpiller> spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;

- (nonnull NSArray *)allKeys;
- (nonnull NSArray *)allValues;

- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeLastObject;
- (void)removeAllObjects;

@end
