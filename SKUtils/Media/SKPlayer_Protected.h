//
//  SKPlayer_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer.h"

#import "SKAsync_Protected.h"

@interface SKPlayer<DataSourceType> () {
@protected
    SKPlayerState _state;
    DataSourceType _source;
    __weak id<SKPlayerDelegate> _delegate;
}

#pragma mark - Abstract

- (void)_setDataSource:(nonnull id)source;
- (void)_prepare:(nullable SKErrorCallback)callback;
- (void)_start:(nullable SKErrorCallback)callback;
- (void)_pause:(nullable SKErrorCallback)callback;
- (void)_stop:(nullable SKErrorCallback)callback;
- (void)_seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)_getCurrentPosition:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)_getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

#pragma mark - Protected

- (void)changeState:(SKPlayerState)newState callback:(nullable SKErrorCallback)callback;
- (void)notifyCompletion:(nullable SKErrorCallback)callback;
- (void)notifyError:(nonnull NSError *)error callback:(nullable SKErrorCallback)callback;
- (void)notifyErrorMessage:(nonnull NSString *)message callback:(nullable SKErrorCallback)callback;
- (void)notifyIllegalStateException:(nullable SKErrorCallback)callback;

@end