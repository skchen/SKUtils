//
//  SKSimplePlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/14.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@interface SKSimplePlayer : SKPlayer

#pragma mark - Abstract

- (void)_start:(nullable SKErrorCallback)callback;
- (void)_resume:(nullable SKErrorCallback)callback;
- (void)_pause:(nullable SKErrorCallback)callback;
- (void)_stop:(nullable SKErrorCallback)callback;

- (void)_setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback;

- (void)_getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)_getProgress:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)_seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

@end
