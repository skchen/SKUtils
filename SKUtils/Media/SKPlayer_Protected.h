//
//  SKPlayer_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer.h"

typedef NS_ENUM(NSUInteger, SKPlayerState) {
    SKPlayerIdle,
    SKPlayerInitialized,
    SKPlayerPreparing,
    SKPlayerPrepared,
    SKPlayerStarted,
    SKPlayerPaused,
    SKPlayerStopped,
    SKPlayerPlaybackCompleted,
    SKPlayerEnd,
    SKPlayerError
};

@interface SKPlayer<DataSourceType> () {
@protected
    SKPlayerState _state;
    DataSourceType _source;
    __weak id<SKPlayerDelegate> _delegate;
}

@property(nonatomic, readonly) SKPlayerState state;

#pragma mark - Abstract

- (nullable NSError *)_setDataSource:(nonnull DataSourceType)source;
- (nullable NSError *)_prepare;
- (nullable NSError *)_start;
- (nullable NSError *)_pause;
- (nullable NSError *)_stop;
- (nullable NSError *)_seekTo:(int)msec;

- (int)getCurrentPosition;
- (int)getDuration;

#pragma mark - Protected

- (void)notifyPrepared;
- (void)notifyStarted;
- (void)notifyStopped;
- (void)notifyCompletion;
- (void)notifyErrorMessage:(nonnull NSString *)message;

@end