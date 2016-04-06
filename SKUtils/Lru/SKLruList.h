//
//  SKLruList.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKLruCoster <NSObject>

- (NSUInteger)costForObject:(nonnull id)object;

@end

@protocol SKLruListSpiller <NSObject>

- (void)onSpilled:(nonnull id)object;

@end

@interface SKLruList : NSObject

@property(nonatomic, assign, readonly) NSUInteger count;

@property(nonatomic, readonly) NSUInteger constraint;
@property(nonatomic, readonly) NSUInteger cost;

@property(nonatomic, weak, nullable) id<SKLruCoster> coster;
@property(nonatomic, weak, nullable) id<SKLruListSpiller> spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andSpiller:(nullable id<SKLruListSpiller>)spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andSpiller:(nullable id<SKLruListSpiller>)spiller;

- (void)touchObject:(nonnull id)object;
- (void)removeObject:(nonnull id)object;
- (void)removeAllObjects;

@end

@interface SKLruSimpleCoster : NSObject<SKLruCoster>
@end
