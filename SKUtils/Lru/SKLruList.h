//
//  SKLruList.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKLruListCoster <NSObject>

- (NSUInteger)costForObject:(nonnull id)object;

@end

@protocol SKLruListSpiller <NSObject>

- (void)onSpilled:(nonnull id)object;

@end

@interface SKLruList : NSObject

@property(nonatomic, readonly) NSUInteger constraint;
@property(nonatomic, readonly) NSUInteger cost;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nonnull id<SKLruListCoster>)coster andSpiller:(nonnull id<SKLruListSpiller>)spiller;

- (void)touchObject:(nonnull id)object;
- (void)removeObject:(nonnull id)object;
- (void)removeAllObjects;

@end
