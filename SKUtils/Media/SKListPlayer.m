//
//  SKListPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKListPlayer.h"

#import "SKPlayer_Protected.h"
#import "SKAbstractClassUtils.h"

@implementation SKListPlayer

#pragma mark - Source

- (void)setSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)addSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)insertSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)go:(NSUInteger)index callback:(SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)previous:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)next:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (BOOL)hasPrevious {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (BOOL)hasNext {
    THROW_NOT_OVERRIDE_EXCEPTION
}

#pragma mark - Mode

- (void)setRepeat:(BOOL)repeat callback:(nullable SKErrorCallback)callback {
    _repeat = repeat;
    [self notifyChangeMode:callback];
}

- (void)setRandom:(BOOL)random callback:(nullable SKErrorCallback)callback {
    _random = random;
    [self notifyChangeMode:callback];
}

@end
