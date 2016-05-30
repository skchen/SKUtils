//
//  SKListPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@interface SKListPlayer<DataSourceType> : SKPlayer <NSArray<DataSourceType> *>

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, assign) BOOL repeat;
@property(nonatomic, assign) BOOL random;

- (nonnull instancetype)initWithPlayer:(nonnull SKPlayer<DataSourceType> *)player;

- (void)setDataSource:(nonnull id)source atIndex:(NSUInteger)index;
- (void)addDataSource:(nonnull DataSourceType)source;
- (void)addDataSource:(nonnull DataSourceType)source atIndex:(NSUInteger)index;

- (void)previous:(nullable SKErrorCallback)callback;
- (void)next:(nullable SKErrorCallback)callback;
- (void)go:(NSUInteger)index callback:(nullable SKErrorCallback)callback;

- (BOOL)hasPrevious;
- (BOOL)hasNext;

@end
