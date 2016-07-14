//
//  SKListPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer.h"

@interface SKListPlayer : SKPlayer {
    @protected
    NSUInteger _index;
}

#pragma mark - Source

@property(nonatomic, readonly) NSUInteger index;

- (void)setSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback;
- (void)addSource:(nonnull id)source callback:(nullable SKErrorCallback)callback;
- (void)addSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback;

- (void)previous:(nullable SKErrorCallback)callback;
- (void)next:(nullable SKErrorCallback)callback;
- (void)go:(NSUInteger)index callback:(nullable SKErrorCallback)callback;

- (BOOL)hasPrevious;
- (BOOL)hasNext;

#pragma mark - Mode

@property(nonatomic, readonly) BOOL repeat;
- (void)setRepeat:(BOOL)repeat callback:(nullable SKErrorCallback)callback;

@property(nonatomic, readonly) BOOL random;
- (void)setRandom:(BOOL)random callback:(nullable SKErrorCallback)callback;

@end
