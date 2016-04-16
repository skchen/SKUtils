//
//  SKLruArray.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKLruCoster <NSObject>

- (NSUInteger)costForObject:(nonnull id)object;

@end

@protocol SKLruArraySpiller <NSObject>

- (void)onSpilled:(nonnull id)object;

@end

@interface SKLruArray : NSObject <NSCoding>

@property(nonatomic, assign, readonly) NSUInteger count;

@property(nonatomic, readonly) NSUInteger constraint;
@property(nonatomic, readonly) NSUInteger cost;

@property(nonatomic, weak, nullable) id<SKLruCoster> coster;
@property(nonatomic, weak, nullable) id<SKLruArraySpiller> spiller;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint;

- (void)touchObject:(nonnull id)object;
- (void)removeObject:(nonnull id)object;
- (void)removeAllObjects;

@end
