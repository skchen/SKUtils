//
//  SKListPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@interface SKListPlayer<DataSourceType> : SKPlayer <NSArray<DataSourceType> *>

@property(nonatomic, strong, readonly, nullable) DataSourceType playing;

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, assign) BOOL repeat;
@property(nonatomic, assign) BOOL random;

- (nonnull instancetype)initWithPlayer:(nonnull SKPlayer<DataSourceType> *)player;

- (nullable NSError *)setDataSource:(nonnull id)source atIndex:(NSUInteger)index;
- (nullable NSError *)addDataSource:(nonnull DataSourceType)source;
- (nullable NSError *)addDataSource:(nonnull DataSourceType)source atIndex:(NSUInteger)index;

- (nullable NSError *)previous;
- (nullable NSError *)next;
- (nullable NSError *)go:(NSUInteger)index;

- (BOOL)hasPrevious;
- (BOOL)hasNext;

@end