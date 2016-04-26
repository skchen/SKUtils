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
@property(nonatomic, readonly) BOOL repeat;
@property(nonatomic, readonly) BOOL random;

- (nonnull instancetype)initWithPlayer:(SKPlayer<DataSourceType> *)player;

- (nullable NSError *)setDataSource:(id)source atIndex:(NSUInteger)index;

- (nullable NSError *)previous;
- (nullable NSError *)next;
- (nullable NSError *)go:(NSUInteger)index;

- (BOOL)hasPrevious;
- (BOOL)hasNext;

@end
