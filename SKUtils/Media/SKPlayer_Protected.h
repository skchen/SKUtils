//
//  SKPlayer_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer.h"

#import "SKAsync_Protected.h"

@interface SKPlayer () {
@protected
    SKPlayerState _state;
    id _source;
    BOOL _looping;
    __weak id<SKPlayerDelegate> _delegate;
}

#pragma mark - Protected

- (void)changeState:(SKPlayerState)newState callback:(nullable SKErrorCallback)callback;
- (void)changeSource:(nullable id)source callback:(nullable SKErrorCallback)callback;

- (void)playbackDidComplete:(nonnull id)playback;

- (void)notifyChangeMode:(nullable SKErrorCallback)callback;
- (void)notifyError:(nonnull NSError *)error callback:(nullable SKErrorCallback)callback;
- (void)notifyErrorMessage:(nonnull NSString *)message callback:(nullable SKErrorCallback)callback;
- (void)notifyIllegalStateException:(nullable SKErrorCallback)callback;

@end